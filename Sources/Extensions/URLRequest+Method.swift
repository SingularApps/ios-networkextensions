import Foundation

public extension URLRequest {
    
    /// Set/Update the HTTP method (verb) for the request (i.e.: GET, POST, PUT)
    /// - Parameter methodString: The method as a String value
    /// - Returns: The modified request
    func setting(methodString: String) -> URLRequest {
        var request = self
        request.httpMethod = methodString
        return request
    }
    
    /// Set/Update the HTTP method (verb) for the request (i.e.: GET, POST, PUT)
    /// - Parameter method: The chosen method using the HTTPMethod enum
    /// - Returns: The modified request
    func setting(method: HTTPMethod) -> URLRequest {
        var request = self
        request.httpMethod = method.value
        return request
    }
}
