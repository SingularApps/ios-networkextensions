import XCTest
@testable import NetworkExtensions

final class URLRequest_QueryItemsTests: XCTestCase {
    
    private var url: URL {
        URL(string: "https://api.server.com/")!
    }

    func testSetRequestQueryItemOnEmptyRequest() throws {
        var request = URLRequest(url: url)
        request.url = nil
        request = request.queryItem(name: "id", value: 10)
        XCTAssertNil(request.url)
    }
    
    func testSetRequestQueryItem() throws {
        let request = URLRequest(url: url)
            .queryItem(name: "id", value: 10)
        XCTAssertNotNil(request.url)
        let components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
        XCTAssertNotNil(components)
        let queryItems = components!.queryItems
        XCTAssertNotNil(queryItems)
        XCTAssertTrue(queryItems!.contains(URLQueryItem(name: "id", value: "10")))
    }
    
    func testUpdateRequestQueryItem() throws {
        let request = URLRequest(url: url)
            .queryItem(name: "id", value: 10)
            .queryItem(name: "id", value: 20)
        XCTAssertNotNil(request.url)
        let components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
        XCTAssertNotNil(components)
        let queryItems = components!.queryItems
        XCTAssertNotNil(queryItems)
        XCTAssertFalse(queryItems!.contains(URLQueryItem(name: "id", value: "10")))
        XCTAssertTrue(queryItems!.contains(URLQueryItem(name: "id", value: "20")))
    }
    
    func testSetRequestQueryItemsWithDictionary() throws {
        let request = URLRequest(url: url)
            .queryItems([
            "id": 10,
            "name": "John"
        ])
        XCTAssertNotNil(request.url)
        let components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
        XCTAssertNotNil(components)
        let queryItems = components!.queryItems
        XCTAssertNotNil(queryItems)
        XCTAssertTrue(queryItems!.contains(URLQueryItem(name: "id", value: "10")))
        XCTAssertTrue(queryItems!.contains(URLQueryItem(name: "name", value: "John")))
    }
    
    func testSetRequestQueryItemsWithEncodable() throws {
        struct Person: Encodable {
            let id: Int
            let name: String
        }
        let request = try URLRequest(url: url)
            .queryItems(Person(id: 10, name: "John"))
        XCTAssertNotNil(request.url)
        let components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
        XCTAssertNotNil(components)
        let queryItems = components!.queryItems
        XCTAssertNotNil(queryItems)
        XCTAssertTrue(queryItems!.contains(URLQueryItem(name: "id", value: "10")))
        XCTAssertTrue(queryItems!.contains(URLQueryItem(name: "name", value: "John")))
    }
}
