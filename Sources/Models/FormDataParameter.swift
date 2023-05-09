import Foundation

/// A protocol to create a form-data parameter
public protocol FormDataParameter {
    
    /// Creates a form-data parameter
    /// - Parameter boundary: The boundary for the request
    /// - Returns: The parameter as Data
    func formData(boundary: String) -> Data?
}
