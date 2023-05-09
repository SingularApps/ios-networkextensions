import XCTest
@testable import NetworkExtensions

class JSONFormDataParameterTests: XCTestCase {
    
    func testEmptyName() throws {
        let parameter = JSONFormDataParameter(name: "", object: "value")
        XCTAssertNil(parameter.formData(boundary: "boundary"))
    }
    
    func testEmptyBoundary() throws {
        let parameter = JSONFormDataParameter(name: "name", object: "value")
        XCTAssertNil(parameter.formData(boundary: ""))
    }
    
    func testValidData() throws {
        struct Person: Codable {
            var name: String
            var age: Int
        }
        let person = Person(name: "Ricardo", age: 35)
        let parameter = JSONFormDataParameter(name: "name", object: person)
        let result = parameter.formData(boundary: "boundary")
        XCTAssertNotNil(result)
        let string = String(data: result!, encoding: .utf8)
        XCTAssertNotNil(string)
        XCTAssertEqual(string, "--boundary\r\nContent-Disposition: form-data; name=\"name\"\r\n\r\n{\"name\":\"Ricardo\",\"age\":35}\r\n")
    }
}
