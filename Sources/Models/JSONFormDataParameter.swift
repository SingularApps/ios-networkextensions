import Foundation

/// Parameter to send JSON values via form-data requests
public struct JSONFormDataParameter {
    
    // MARK: - Properties
    
    /// The name of the parameter
    public let name: String
    
    /// The JSON value
    public let value: String
    
    // MARK: - Initialization
    
    /// Creates a new parameter
    /// - Parameters:
    ///   - name: The name of the parameter
    ///   - object: The source object
    ///   - encoder: The JSON encoder
    ///   - stringEncoding: The encoding strategy
    public init<Type: Encodable>(name: String,
                                 object: Type,
                                 encoder: JSONEncoder = JSONEncoder(),
                                 stringEncoding: String.Encoding = .utf8) {
        
        self.name = name
        var value = ""
        if let data = try? encoder.encode(object),
           let description = String(data: data, encoding: stringEncoding) {
            value = description
        }
        self.value = value
    }
}

// MARK: - FormDataParameter
extension JSONFormDataParameter: FormDataParameter {
    
    public func formData(boundary: String) -> Data? {
        guard !name.isEmpty,
              !value.isEmpty,
              !boundary.isEmpty
        else {
            return nil
        }
        var formContent = "--" + boundary + "\r\n"
        formContent += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        formContent += "\r\n"
        formContent += value + "\r\n"
        return formContent.data(using: .utf8)
    }
}

