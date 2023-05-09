import Foundation

public extension URLRequest {
    
    /// Set/Replace headers with a dictionary
    /// - Parameter headers: A dictionary with headers
    /// - Returns: The modified request
    func setting(headers: [String: Any]) -> URLRequest {
        var request = self
        for (key, value) in headers {
            request.setValue(String(describing: value), forHTTPHeaderField: key)
        }
        return request
    }
    
    /// Set/Update a header with key and value. It will use String(describing: value) as the value should be a string
    /// - Parameters:
    ///   - key: The key of the header
    ///   - value: The value of the header
    /// - Returns: The modified request
    func settingHeader(key: String, value: Any) -> URLRequest {
        var request = self
        request.setValue(String(describing: value), forHTTPHeaderField: key)
        return request
    }
    
    /// Set/Update the authorization header with a token
    /// - Parameter scheme: The scheme for the authorization, the default is Bearer
    /// - Parameter token: The token for the authorization
    /// - Returns: The modified request
    func settingAuthorization(scheme: String = "Bearer", token: String) -> URLRequest {
        self.settingHeader(key: "Authorization", value: "\(scheme) \(token)")
    }
}
