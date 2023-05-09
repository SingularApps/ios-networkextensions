import Foundation

public extension URLRequest {
    
    /// Creates/Executes a data task for the request
    /// - Parameters:
    ///   - session: The session to create the task
    ///   - autoResume: The option to automatically resume the task once it's created
    ///   - callback: The results of the task execution
    /// - Returns: The created task
    func dataTask(on session: URLSession = .shared,
                  autoResume: Bool = true,
                  callback: ((Data?, URLResponse?, Error?) -> Void)? = nil) -> URLSessionDataTask {
        let task = session.dataTask(with: self) { data, response, error in
            callback?(data, response, error)
        }
        if autoResume {
            task.resume()
        }
        return task
    }
    
    @available(macOS 12.0, *)
    @available(iOS 15.0, *)
    /// Executes a data task for the request
    /// - Parameter session: The session to execute the task
    /// - Returns: The results of the task
    func send(on session: URLSession = .shared) async throws -> (Data, URLResponse) {
        try await session.data(for: self)
    }
}
