import Foundation

public extension URLRequest {
    
    /// Set/Update the ContentType header to "multipart/form-data"
    /// - Parameter boundary: The boundary for the request
    /// - Returns: The modified request
    func formDataContentType(boundary: String) -> URLRequest {
        self.settingHeader(key: "Content-Type", value: "multipart/form-data; boundary=" + boundary)
    }
    
    /// Set/Update the body as a JSON object from a list of parameters
    /// - Parameters:
    ///   - parameters: An array of parameters
    ///   - boundary: The boundary for the request
    /// - Returns: The modified request
    func formData(with parameters: [FormDataParameter], boundary: String = UUID().uuidString) throws -> URLRequest {
        var request = self
            .formDataContentType(boundary: boundary)
        var data = Data()
        for parameter in parameters {
            if let formData = parameter.formData(boundary: boundary) {
                data.append(formData)
            }
        }
        if let formData = "--\(boundary)--\r\n".data(using: .utf8) {
            data.append(formData)
        }
        request.httpBody = data
        return request
    }
}
