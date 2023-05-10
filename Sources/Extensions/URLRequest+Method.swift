import Foundation

public extension URLRequest {
    
    /// Set/Update the HTTP method (verb) for the request (i.e.: GET, POST, PUT)
    /// - Parameter methodString: The method as a String value
    /// - Returns: The modified request
    func method(_ methodString: String) -> URLRequest {
        var request = self
        request.httpMethod = methodString.uppercased()
        return request
    }
}
