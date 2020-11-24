import Foundation
import CSV
import Combine
import ISO8859
@available(iOS 13.0, *)
public class WineCellar: ObservableObject {
    @Published public var inventory: ResponseType = .pending

    public init() {}

    private let dataDirectorPath = "cellarTracker/"
    private let fileName = "cellar"
    private let fileExtension = "csv"

    private func updateInventory(responseType: ResponseType) {
        DispatchQueue.main.async {
            self.inventory = responseType
        }
    }

    private var localCSVDirectory: URL? {
        let fileManager = FileManager.default
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
        } catch {
            updateInventory(responseType: .failure(.unableToRemoveCachedWineList))
            // non fatal error, keep it going
        }
    }

    public func refreshCellar(uname: String, password: String, forceRefresh: Bool = false) {
        // fetch from URL
        guard let cellarTrackerURL = URL(string: "https://www.cellartracker.com/xlquery.asp?User=\(uname)&Password=\(password)&Format=csv&Table=List&Location=1") else {
            fatalError()
        }

        let fileManager = FileManager.default

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
                    try fileManager.moveItem(at: url, to: localURL)
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
            let iso88591Data = try Data(contentsOf: localCSVURL)
            guard let csvString = String(iso88591Data, iso8859Encoding: ISO8859.part1) else {
                updateInventory(responseType: .failure(.unableToParseWineList))
                return
            }
            let csv = try CSVReader(string: csvString, hasHeaderRow: true)
            let decoder = CSVRowDecoder()
            var bottles = [Bottle]()
            while csv.next() != nil {
                let row = try! decoder.decode(Bottle.self, from: csv)
                bottles.append(row)
            }
            updateInventory(responseType: .success(bottles))
        } catch {
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
