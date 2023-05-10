import Foundation

public extension URLRequest {
    
    /// Create a new request using the base URL and endpoint
    /// - Parameters:
    ///   - endpoint: The chosen endpoint
    init(stringUrl: String) throws {
        guard let url = URL(string: stringUrl) else {
            throw NetworkingError.invalidURL
        }
        self.init(url: url)
    }
}
