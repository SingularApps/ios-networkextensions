import XCTest
@testable import NetworkExtensions

final class URLRequest_JSONTests: XCTestCase {
    
    private var url: URL {
        URL(string: "https://api.server.com/")!
    }

    func testSetRequestJSONContentType() throws {
        var request = URLRequest(url: url)
        XCTAssertNil(request.allHTTPHeaderFields)
        request = request.jsonContentType()
        XCTAssertEqual(request.allHTTPHeaderFields?["Content-Type"], "application/json")
    }
    
    func testSetRequestJSONBodyWithEncodableObject() throws {
        struct Person: Codable, Equatable {
            let name: String
            let age: Int
        }
        let parameters = Person(name: "John", age: 30)
        let request = try URLRequest(url: url)
            .json(parameters)
        XCTAssertNotNil(request.httpBody)
        let body = try JSONDecoder().decode(Person.self, from: request.httpBody!)
        XCTAssertEqual(parameters, body)
    }
    
    func testSetRequestJSONBodyWithDictionary() throws {
        let parameters: [String: Any] = [
            "name": "John",
            "age": 30
        ]
        let request = try URLRequest(url: url)
            .json(parameters)
        XCTAssertNotNil(request.httpBody)
        let body = try JSONSerialization.jsonObject(with: request.httpBody!) as? [String: Any]
        XCTAssertNotNil(body)
        XCTAssertNotNil(body?["name"])
        XCTAssertEqual(parameters["name"] as? String, body?["name"] as? String)
        XCTAssertNotNil(body?["age"])
        XCTAssertEqual(parameters["age"] as? Int, body?["age"] as? Int)
    }
}
