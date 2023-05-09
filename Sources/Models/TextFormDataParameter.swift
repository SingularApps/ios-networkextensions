import Foundation

/// Parameter to send text values via form-data requests
public struct TextFormDataParameter {

    // MARK: - Properties
    
    /// The name of the parameter
    public let name: String
    
    /// The text value
    public let value: String
    
    // MARK: - Initialization
    
    /// Creates a new parameter
    /// - Parameters:
    ///   - name: The name of the parameter
    ///   - value: The text value
    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

// MARK: - FormDataParameter
extension TextFormDataParameter: FormDataParameter {

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
