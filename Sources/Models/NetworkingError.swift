import Foundation

/// Errors created within the module
public enum NetworkingError: Error, Equatable {
    
    case invalidURL
    case couldNotDecodeResponseData
}
