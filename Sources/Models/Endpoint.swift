import Foundation

/// The endpoint protocol to be used when making requests to the server
public protocol Endpoint {
    
    var path: String { get }
}

