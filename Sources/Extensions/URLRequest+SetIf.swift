import Foundation

public extension URLRequest {
    
    /// Executes an action if a condition is true. It can also have an otherwise callback.
    /// - Parameters:
    ///   - condition: Condition to be checked
    ///   - callbackTrue: Closure when the test result is true
    ///   - callbackFalse: Closure when the test result is false
    /// - Returns: The modified request
    func setIf(_ condition: Bool,
               isTrue callbackTrue: (URLRequest) -> URLRequest,
               otherwise callbackFalse: ((URLRequest) -> URLRequest)? = nil) -> URLRequest {
        if condition {
            return callbackTrue(self)
        }
        return callbackFalse?(self) ?? self
    }
}
