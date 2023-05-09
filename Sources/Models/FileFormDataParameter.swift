import Foundation

/// Parameter to send files via form-data requests
public struct FileFormDataParameter {
    
    // MARK: - Properties
    
    /// The name of the parameter
    public let name: String
    
    /// The name of the file
    public let filename: String
    
    /// The content type of the file (i.e.: image/jpg)
    public let contentType: String
    
    /// The file content
    public let data: Data
    
    // MARK: - Initialization
    
    /// Creates a new parameter
    /// - Parameters:
    ///   - name: The name of the parameter
    ///   - filename: The name of the file
    ///   - contentType: The content type of the file (i.e.: image/jpg)
    ///   - data: The file content
    public init(name: String,
                filename: String,
                contentType: String,
                data: Data) {
        
        self.name = name
        self.filename = filename
        self.contentType = contentType
        self.data = data
    }
}

// MARK: - FormDataParameter
extension FileFormDataParameter: FormDataParameter {
    
    public func formData(boundary: String) -> Data? {
        guard !name.isEmpty,
            !filename.isEmpty,
            !contentType.isEmpty,
            !boundary.isEmpty
            else {
                return nil
        }
        var formData = Data()
        var formContent = "--" + boundary + "\r\n"
        formContent += "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n"
        formContent += "Content-Type: \"\(contentType)\"\r\n"
        formContent += "\r\n"
        if let parameterData = formContent.data(using: .utf8) {
            formData.append(parameterData)
        }
        formData.append(data)
        formContent = "\r\n"
        if let parameterData = formContent.data(using: .utf8) {
            formData.append(parameterData)
        }
        return formData
    }
}
