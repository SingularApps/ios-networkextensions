import XCTest
@testable import NetworkExtensions

final class URLResponse_HeadersTests: XCTestCase {

    func testResponseHeadersInvalid() throws {
        let response = URLResponse()
        XCTAssertNil(response.headers)
    }
    
    func testResponseHeadersValid() throws {
        let response = HTTPURLResponse(
            url: URL(string: "http://server.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["name": "John"]
        )
        XCTAssertEqual(response?.headers?["name"] as? String, "John")
    }
}
