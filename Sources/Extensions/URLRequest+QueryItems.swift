import Foundation

public extension URLRequest {
    
    /// Set/Update query item
    /// - Parameters:
    ///   - name: The key of the query item
    ///   - value: The value of the query item
    /// - Returns: The modified request
    func settingQueryItem(name: String, value: Any) -> URLRequest {
        guard let url = self.url,
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            return self
        }
        var queryItems = components.queryItems ?? []
        let stringValue = String(describing: value)
        if let index = queryItems.firstIndex(where: { $0.name == name }) {
            queryItems.remove(at: index)
        }
        queryItems.append(URLQueryItem(name: name, value: stringValue))
        components.queryItems = queryItems
        var request = self
        request.url = components.url
        return request
    }
    
    /// Set/Update query item with a dictionary
    /// - Parameter parameters: A dictionary with query items
    /// - Returns: The modified request
    func settingQueryItems(with parameters: [String: Any]) -> URLRequest {
        var request = self
        for (name, value) in parameters {
            request = request.settingQueryItem(name: name, value: value)
        }
        return request
    }
    
    /// Set/Update query item with an encodable object
    /// - Parameters:
    ///   - source: An encodable object
    ///   - encoder: A JSONEncoder object
    /// - Returns: The modified request
    func settingQueryItems<T: Encodable>(with source: T, encoder: JSONEncoder = JSONEncoder()) throws -> URLRequest {
        let encoded = try encoder.encode(source)
        let jsonObject = try JSONSerialization.jsonObject(with: encoded, options: .mutableContainers)
        let parameters = try anyToDictionary(jsonObject)
        return self.settingQueryItems(with: parameters)
    }
}

