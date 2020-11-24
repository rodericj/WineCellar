import Foundation
enum WineError: Error {
    case writeFail
    case unableToParseWineList
}

public enum ResponseType {
    case success([Bottle])
    case failure(Error)
    case pending
}
