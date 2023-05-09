import XCTest
@testable import NetworkExtensions

final class URLRequest_MethodTests: XCTestCase {
    
    private var url: URL {
        URL(string: "https://api.server.com/")!
    }

    func testSetRequestMethodWithString() throws {
        var request = URLRequest(url: url)
        XCTAssertEqual(request.httpMethod, "GET")
        request = request
            .setting(methodString: "POST")
        XCTAssertEqual(request.httpMethod, "POST")
    }
    
    func testSetRequestMethodWithEnum() throws {
        var request = URLRequest(url: url)
        XCTAssertEqual(request.httpMethod, "GET")
        request = request
            .setting(method: .delete)
        XCTAssertEqual(request.httpMethod, "DELETE")
    }
}
