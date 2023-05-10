import Foundation

/// The endpoint protocol to be used when making requests to the server
public protocol Endpoint {
    
    var method: HTTPMethod { get }
    var path: String { get }
}

