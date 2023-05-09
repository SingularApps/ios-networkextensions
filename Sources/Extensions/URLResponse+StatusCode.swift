import Foundation

public extension URLResponse {
    
    /// The status code from an HTTP response
    var httpStatusCode: HTTPStatusCode? {
        HTTPStatusCode(rawValue: (self as? HTTPURLResponse)?.statusCode ?? -999)
    }
}
