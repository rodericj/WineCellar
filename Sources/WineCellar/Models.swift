import Foundation
public enum WineError: Error {
    case writeFail
    case unableToParseWineList
    case unableToReadDocumentsDirectory
    case unableToReadCellarDirectory
    case missingUsernameOrPassword
    case unableToCreateCellarDirectory
    case unableToMoveDownloadedDataToStorage
    case unableToRemoveCachedWineList
    case unknown(Error)
}

public enum ResponseType {
    case success([Bottle])
    case failure(WineError)
    case pending
}
