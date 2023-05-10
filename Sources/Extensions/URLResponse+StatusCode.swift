import Foundation

public extension URLResponse {
    
    /// The status code from an HTTP response
    var httpStatusCode: Int? {
        (self as? HTTPURLResponse)?.statusCode ?? -999
    }
}
