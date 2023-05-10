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
    
    /// Creates/Executes a data task for the request waiting for a decodable object
    /// - Parameters:
    ///   - session: The session to create the task
    ///   - source: The source type for the response
    ///   - decoder: The decoder to decode the response data
    ///   - autoResume: The option to automatically resume the task once it's created
    ///   - callback: The results of the task execution
    /// - Returns: The created task
    func dataTask<T: Decodable>(on session: URLSession = .shared,
                                waitingFor source: T.Type,
                                decoder: JSONDecoder = JSONDecoder(),
                                autoResume: Bool = true,
                                callback: ((T?, Error?) -> Void)? = nil) -> URLSessionDataTask {
        dataTask(on: session, autoResume: autoResume) { data, response, error in
            if let error = error {
                callback?(nil, error)
                return
            }
            guard let object: T = data?.jsonObject(decoder: decoder) else {
                callback?(nil, NetworkingError.couldNotDecodeResponseData)
                return
            }
            callback?(object, error)
        }
    }
    
    @available(macOS 12.0, *)
    @available(iOS 15.0, *)
    /// Executes a data task for the request
    /// - Parameter session: The session to execute the task
    /// - Returns: The results of the task
    func send(on session: URLSession = .shared) async throws -> (Data, URLResponse) {
        try await session.data(for: self)
    }
    
    @available(macOS 12.0, *)
    @available(iOS 15.0, *)
    /// Executes a data task for the request waiting for a decodable object
    /// - Parameters:
    ///   - session: The session to execute the task
    ///   - source: The source type for the response
    ///   - decoder: The decoder to decode the response data
    /// - Returns: The returned object
    func send<T: Decodable>(on session: URLSession = .shared,
                            waitingFor source: T.Type,
                            decoder: JSONDecoder = JSONDecoder()) async throws -> T {
        let (data, _) = try await send(on: session)
        guard let object: T = data.jsonObject(decoder: decoder) else {
            throw NetworkingError.couldNotDecodeResponseData
        }
        return object
    }
}
