import Foundation
import CSV
import Combine
import ISO8859

public class WineCellar {
    @Published public var inventory: ResponseType = .pending

    public init() {}

    public func refreshCellar(uname: String, password: String) {
        // fetch from URL

        guard let url = URL(string: "https://www.cellartracker.com/xlquery.asp?User=\(uname)&Password=\(password)&Format=csv&Table=List&Location=1") else {
            fatalError()
        }

        let task = URLSession.shared.downloadTask(with: url) { [weak self] (url, response, error)  in
            if let error = error {
                self?.inventory = .failure(error)
            }
            if let url = url {
                do {
                    let iso88591Data = try Data(contentsOf: url)
                    guard let csvString = String(iso88591Data, iso8859Encoding: ISO8859.part1) else {
                        self?.inventory = .failure(WineError.unableToParseWineList)
                        return
                    }
                    let csv = try CSVReader(string: csvString, hasHeaderRow: true)
                    let decoder = CSVRowDecoder()
                    var bottles = [Bottle]()
                    while csv.next() != nil {
                        let row = try! decoder.decode(Bottle.self, from: csv)
                        bottles.append(row)
                    }
                    self?.inventory = .success(bottles)
                } catch {
                    self?.inventory = .failure(error)
                }
            }
        }
        task.resume()
    }

    public func wines() throws {
        print("Show the cached wines")
    }
}

extension WineCellar {
    private func data(element: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let httpResponse = element.response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
//            semaphore.signal()
            throw URLError(.badServerResponse)
        }
        return element.data
    }
}
