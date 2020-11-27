import Foundation
import CSV
import Combine
import ISO8859
import KeychainAccess
@available(iOS 13.0, *)
public class WineCellar: ObservableObject {

    @Published public var bottles: [Bottle] = []
    @Published public var error: WineError? = nil
    @Published public var authenticatedSuccessfully: Bool = false

    private let fileManager = FileManager.default
    public init() {}

    private let dataDirectorPath = "cellarTracker/"
    private let fileName = "cellar"
    private let fileExtension = "csv"

    public func refreshAuthStatus() {
        if let localCSVURL = localCSVURL, fileManager.fileExists(atPath: localCSVURL.relativePath) {
            authenticatedSuccessfully = true
            readWineList(from: localCSVURL)
        } else {
            authenticatedSuccessfully = false
        }
    }

    private func updateInventory(responseType: ResponseType) {
        DispatchQueue.main.async {
            switch responseType {
            case .success(let bottles):
                self.authenticatedSuccessfully = !bottles.isEmpty
                self.bottles = bottles
            case .failure(let error):
                self.error = error
            case .pending:
                self.authenticatedSuccessfully = false
                self.error = nil
                self.bottles = []
            }
        }
    }

    private var localCSVDirectory: URL? {
        guard let docsDirs = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            updateInventory(responseType: .failure(.unableToReadDocumentsDirectory))
            return nil
        }
        return docsDirs.appendingPathComponent(dataDirectorPath, isDirectory: true)
    }

    private var localCSVURL: URL? {
        return localCSVDirectory?.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
    }

    private func removeExistingWineList(from localCSVURL: URL, with fileManager: FileManager) {
        do {
            try fileManager.removeItem(at: localCSVURL)
            updateInventory(responseType: .pending)
        } catch {
            updateInventory(responseType: .failure(.unableToRemoveCachedWineList))
            // non fatal error, keep it going
        }
    }
    let keychain = Keychain(service: "io.thumbworks.winecellar")

    public func logout() {
        try? keychain.removeAll()
        guard let localCSVURL = localCSVURL else {
            updateInventory(responseType: .failure(.unableToReadCellarDirectory))
            return
        }
        removeExistingWineList(from: localCSVURL, with: fileManager)
    }

    public func refreshCellar(uname: String, password: String) {
        keychain[uname] = password
        refresh(forceRefresh: true)
    }

    public func refresh(forceRefresh: Bool = false) {
        guard let userName = keychain.allItems().compactMap({ item in
            item["key"] as? String
        }).first,
        let password = keychain[userName] else {
            print("couldn't find username or password in keychain, try again")
            updateInventory(responseType: .failure(.missingUsernameOrPassword))
            return
        }
        print("username fetched from keychain \(userName) \(password)")

        // fetch from URL
        guard let cellarTrackerURL = URL(string: "https://www.cellartracker.com/xlquery.asp?User=\(userName)&Password=\(password)&Format=csv&Table=List&Location=1") else {
            fatalError()
        }

        guard let localCSVURL = localCSVURL else {
            updateInventory(responseType: .failure(.unableToReadCellarDirectory))
            return
        }
        if forceRefresh {
            removeExistingWineList(from: localCSVURL, with: fileManager)
        } else if fileManager.fileExists(atPath: localCSVURL.relativePath) {
            debugPrint("this file exists and we aren't forcing a refresh. Use the local file")
            readWineList(from: localCSVURL)
            return
        }

        guard let localCSVDirectory = localCSVDirectory else {
            updateInventory(responseType: .failure(.unableToReadDocumentsDirectory))
            return
        }
        do {
            try fileManager.createDirectory(at: localCSVDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            updateInventory(responseType: .failure(.unableToCreateCellarDirectory))
        }

        debugPrint("fetching from the server")

        let task = URLSession.shared.downloadTask(with: cellarTrackerURL) { [weak self] (url, response, error)  in
            if let error = error {
                self?.updateInventory(responseType: .failure(.unknown(error)))
            }
            if let url = url, let localURL = self?.localCSVURL {
                do {
                    debugPrint("moving the temp to \(localURL)")
                    try self?.fileManager.moveItem(at: url, to: localURL)
                    debugPrint("we've moved it to \(localURL), now read it")
                    self?.readWineList(from: localURL)
                } catch {
                    debugPrint("some kind of failure, unable to move")
                    self?.updateInventory(responseType: .failure(.unknown(error)))
                }
            }
        }
        task.resume()
    }

    private func readWineList(from localCSVURL: URL) {
        do {
            debugPrint("read contents from file")
            let iso88591Data = try Data(contentsOf: localCSVURL)
            guard let csvString = String(iso88591Data, iso8859Encoding: ISO8859.part1) else {
                debugPrint("unable to parse the list")
                updateInventory(responseType: .failure(.unableToParseWineList))
                return
            }
            debugPrint("begin parsing")
            let csv = try CSVReader(string: csvString, hasHeaderRow: true)
            let decoder = CSVRowDecoder()
            var bottles = [Bottle]()
            while csv.next() != nil {
                let row = try! decoder.decode(Bottle.self, from: csv)
                debugPrint("parsed \(row)")
                bottles.append(row)
            }
            debugPrint("successfully parsed the bottle list \(bottles)")
            updateInventory(responseType: .success(bottles))
        } catch {
            debugPrint("failed with an error \(error)")
            updateInventory(responseType: .failure(.unknown(error)))
        }
    }
}

@available(iOS 13.0, *)
extension WineCellar {
    private func data(element: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let httpResponse = element.response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return element.data
    }
}
