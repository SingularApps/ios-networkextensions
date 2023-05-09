import Foundation

/// Errors when trying to cast
enum CastingError: Error {
    case invalidSource
}

/// This is an internal method to cast Any to a Dictionary
/// - Parameter any: Any source (i.e.: String, Codable struct)
/// - Throws: Invalid source when not able to cast
/// - Returns: The new dictionary
func anyToDictionary(_ any: Any) throws -> [String: Any] {
    guard let result = any as? [String: Any] else {
        throw CastingError.invalidSource
    }
    return result
}
