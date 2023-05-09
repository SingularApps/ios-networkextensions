import Foundation

public extension URLRequest {
    
    /// The base URL for new requests
    static var baseUrl = ""
    
    /// Create a new request using the base URL and endpoint
    /// - Parameters:
    ///   - endpoint: The chosen endpoint
    init(endpoint: String = "") throws {
        let urlString = URLRequest.baseUrl + endpoint
        guard let url = URL(string: urlString) else {
            throw NetworkingError.invalidURL
        }
        self.init(url: url)
    }
    
    /// Create a new request using the  base URL and endpoint
    /// - Parameters:
    ///   - endpoint: The chosen endpoint
    init(endpoint: Endpoint) throws {
        try self.init(endpoint: endpoint.path)
    }
}
