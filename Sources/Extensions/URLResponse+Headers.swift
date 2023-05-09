import Foundation

public extension URLResponse {
    
    /// The headers from an HTTP response
    var headers: [AnyHashable: Any]? {
        (self as? HTTPURLResponse)?.allHeaderFields
    }
}
