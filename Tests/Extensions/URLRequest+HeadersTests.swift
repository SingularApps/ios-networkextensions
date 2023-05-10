import XCTest
@testable import NetworkExtensions

final class URLRequest_HeadersTests: XCTestCase {
    
    private var url: URL {
        URL(string: "https://api.server.com/")!
    }

    // MARK: - Set/Update headers
    
    func testSetRequestHeaders() throws {
        var request = URLRequest(url: url)
        XCTAssertNil(request.allHTTPHeaderFields)
        request = request.headers([
            "Content-Type": "application/json",
            "Authorization": "Bear abcd"
        ])
        XCTAssertEqual(request.allHTTPHeaderFields?["Content-Type"], "application/json")
        XCTAssertEqual(request.allHTTPHeaderFields?["Authorization"], "Bear abcd")
    }
    
    func testUpdateRequestHeaders() throws {
        var request = URLRequest(url: url)
            .headers([
                "Content-Type": "text/plain"
            ])
        XCTAssertEqual(request.allHTTPHeaderFields?["Content-Type"], "text/plain")
        request = request.headers([
            "Content-Type": "application/json",
            "Authorization": "Bear abcd"
        ])
        XCTAssertEqual(request.allHTTPHeaderFields?["Content-Type"], "application/json")
        XCTAssertEqual(request.allHTTPHeaderFields?["Authorization"], "Bear abcd")
    }
    
    // MARK: - Set/Update a header
    
    func testSetRequestHeader() throws {
        var request = URLRequest(url: url)
        XCTAssertNil(request.allHTTPHeaderFields)
        request = request
            .header(name: "Content-Type", value: "application/json")
            .header(name: "Number", value: 10)
        XCTAssertNotNil(request.allHTTPHeaderFields)
        XCTAssertEqual(request.allHTTPHeaderFields!["Content-Type"]!, "application/json")
        XCTAssertEqual(Int(request.allHTTPHeaderFields!["Number"]!), 10)
    }
    
    func testUpdateRequestHeader() throws {
        var request = URLRequest(url: url)
            .header(name: "Content-Type", value: "text/plain")
            .header(name: "Number", value: 5)
        XCTAssertNotNil(request.allHTTPHeaderFields)
        XCTAssertEqual(request.allHTTPHeaderFields!["Content-Type"]!, "text/plain")
        XCTAssertEqual(Int(request.allHTTPHeaderFields!["Number"]!), 5)
        request = request
            .header(name: "Content-Type", value: "application/json")
            .header(name: "Number", value: 10)
        XCTAssertNotNil(request.allHTTPHeaderFields)
        XCTAssertEqual(request.allHTTPHeaderFields!["Content-Type"]!, "application/json")
        XCTAssertEqual(Int(request.allHTTPHeaderFields!["Number"]!), 10)
    }
    
    // MARK: - Set/Update Authorization
    
    func testSetRequestAuthHeader() throws {
        var request = URLRequest(url: url)
        XCTAssertNil(request.allHTTPHeaderFields)
        request = request
            .authorization(token: "abcde")
        XCTAssertEqual(request.allHTTPHeaderFields?["Authorization"], "Bearer abcde")
    }
}
