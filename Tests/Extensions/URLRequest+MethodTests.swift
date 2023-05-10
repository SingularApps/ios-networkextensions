import XCTest
@testable import NetworkExtensions

final class URLRequest_MethodTests: XCTestCase {
    
    private var url: URL {
        URL(string: "https://api.server.com/")!
    }

    func testSetRequestMethod() throws {
        var request = URLRequest(url: url)
        XCTAssertEqual(request.httpMethod, "GET")
        request = request
            .method("post")
        XCTAssertEqual(request.httpMethod, "POST")
    }
}
