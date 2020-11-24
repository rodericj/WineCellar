import Foundation
public enum WineError: Error {
    case writeFail
    case unableToParseWineList
    case unableToReadDocumentsDirectory
    case unableToReadCellarDirectory
    case unableToCreateCellarDirectory
    case unableToMoveDownloadedDataToStorage
    case unknown(Error)
}

public enum ResponseType {
    case success([Bottle])
    case failure(WineError)
    case pending
}
