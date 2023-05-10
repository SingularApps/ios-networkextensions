import Foundation

public extension URLRequest {
    
    /// Set/Update the ContentType header to "application/json"
    /// - Returns: The modified request
    func jsonContentType() -> URLRequest {
        self.header(name: "Content-Type", value: "application/json")
    }
    
    /// Set/Update the body as a JSON object from an Encodable object
    /// - Parameters:
    ///   - parameters: An encodable object
    ///   - encoder: A JSONEncoder object
    /// - Returns: The modified request
    func json<T: Encodable>(_ parameters: T, encoder: JSONEncoder = JSONEncoder()) throws -> URLRequest {
        var request = self
            .jsonContentType()
        request.httpBody = try encoder.encode(parameters)
        return request
    }
    
    /// Set/Update the body as a JSON object from a Dictionary
    /// - Parameter parameters: A Dictionary
    /// - Returns: The modified request
    func json(_ parameters: [String: Any]) throws -> URLRequest {
        var request = self
            .jsonContentType()
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        return request
    }
}
