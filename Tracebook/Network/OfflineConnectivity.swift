import Foundation

extension Error {
    var isOfflineConnectivityFailure: Bool {
        let error = self as NSError

        if error.domain == NSURLErrorDomain {
            return error.code == URLError.notConnectedToInternet.rawValue
                || error.code == URLError.networkConnectionLost.rawValue
        }

        if let underlyingError = error.userInfo[NSUnderlyingErrorKey] as? Error {
            return underlyingError.isOfflineConnectivityFailure
        }

        return false
    }
}
