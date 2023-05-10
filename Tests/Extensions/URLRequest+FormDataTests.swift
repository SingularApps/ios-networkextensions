import XCTest
@testable import NetworkExtensions

final class URLRequest_FormDataTests: XCTestCase {
    
    private var url: URL {
        URL(string: "https://api.server.com/")!
    }

    func testSetRequestFormDataContentType() throws {
        var request = URLRequest(url: url)
        XCTAssertNil(request.allHTTPHeaderFields)
        let boundary = UUID().uuidString
        request = request.formDataContentType(boundary: boundary)
        XCTAssertEqual(request.allHTTPHeaderFields?["Content-Type"], "multipart/form-data; boundary=" + boundary)
    }
    
    func testSetRequestFormDataBody() throws {
        struct Person: Codable {
            let age: Int
        }
        let parameters: [FormDataParameter] = [
            TextFormDataParameter(name: "name", value: "John"),
            FileFormDataParameter(
                name: "image",
                filename: "image.jpg",
                contentType: "image/jpg",
                data: "file contents".data(using: .utf8)!
            ),
            JSONFormDataParameter(name: "person", object: Person(age: 30))
        ]
        let boundary = UUID().uuidString
        let request = try URLRequest(url: url)
            .formData(parameters, boundary: boundary)
        XCTAssertEqual(request.allHTTPHeaderFields?["Content-Type"], "multipart/form-data; boundary=" + boundary)
        XCTAssertNotNil(request.httpBody)
        let result = String(data: request.httpBody!, encoding: .utf8)
        XCTAssertNotNil(result)
        XCTAssertTrue(result!.contains(boundary))
        XCTAssertTrue(result!.contains("name"))
        XCTAssertTrue(result!.contains("John"))
        XCTAssertTrue(result!.contains("image"))
        XCTAssertTrue(result!.contains("image.jpg"))
        XCTAssertTrue(result!.contains("image/jpg"))
        XCTAssertTrue(result!.contains("person"))
        XCTAssertTrue(result!.contains("30"))
    }
}
