import Foundation

public extension Data {
    
    /// The default decoder for JSON objects
    static var defaultJSONDecoder = JSONDecoder()
    
    /// Converts Data into Int
    var intValue: Int? {
        Int(stringValue() ?? "")
    }
    
    /// Converts Data into Float
    var floatValue: Float? {
        Float(stringValue() ?? "")
    }
    
    /// Converts Data into Double
    var doubleValue: Double? {
        Double(stringValue() ?? "")
    }
    
    /// Converts Data into an Array of Any
    var arrayValue: [Any]? {
        try? JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? [Any]
    }
    
    /// Converts Data into a Dictionary with String key and Any value
    var dictionaryValue: [String: Any]? {
        try? JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? [String: Any]
    }
    
    /// Converts Data into String
    var stringValue: String? {
        stringValue()
    }
    
    /// Converts Data into String
    /// - Parameter encoding: The String encoding
    /// - Returns: The String value
    func stringValue(encoding: String.Encoding = .utf8) -> String? {
        String(data: self, encoding: encoding)
    }
    
    /// Converts Data into a JSON object
    /// - Parameter decoder: The JSON decoder
    /// - Returns: The new object
    func jsonObject<T: Decodable>(decoder: JSONDecoder = defaultJSONDecoder) -> T? {
        try? decoder.decode(T.self, from: self)
    }
}
