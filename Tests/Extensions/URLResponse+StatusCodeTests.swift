import XCTest
@testable import NetworkExtensions

final class URLResponse_StatusCodeTests: XCTestCase {

    func testResponseStatusCodeInvalid() throws {
        let response = URLResponse()
        XCTAssertEqual(response.httpStatusCode, .error)
    }
    
    func testResponseStatusCodeValid() throws {
        let response = HTTPURLResponse(
            url: URL(string: "http://server.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        XCTAssertEqual(response?.httpStatusCode, .ok)
    }
}
