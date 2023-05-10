import XCTest
@testable import NetworkExtensions

final class URLRequest_SetIfTests: XCTestCase {

    private var url: URL {
        URL(string: "https://api.server.com/")!
    }
    
    func testConditionIsTrue() throws {
        let request = URLRequest(url: url)
            .setIf(1 == 1) { request in
                var request = request
                request.httpMethod = "POST"
                return request
            }
        XCTAssertEqual(request.httpMethod, "POST")
    }
    
    func testConditionIsFalse() throws {
        let request = URLRequest(url: url)
            .setIf(1 == 2) { request in
                var request = request
                request.httpMethod = "POST"
                return request
            }
        XCTAssertEqual(request.httpMethod, "GET")
    }
    
    func testOtherwise() throws {
        let request = URLRequest(url: url)
            .setIf(1 == 2) { request in
                request.method(.post)
            } otherwise: { request in
                request.method(.delete)
            }
        XCTAssertEqual(request.httpMethod, "DELETE")
    }
}
