import Foundation

public extension URLRequest {
    
    /// Create a new request using a string as URL
    /// - Parameters:
    ///   - stringUrl: The URL string
    init(stringUrl: String) throws {
        guard let url = URL(string: stringUrl) else {
            throw NetworkingError.invalidURL
        }
        self.init(url: url)
    }
}
