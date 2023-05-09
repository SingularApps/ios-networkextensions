import XCTest
@testable import NetworkExtensions

class TextFormDataParameterTests: XCTestCase {
    
    func testEmptyName() throws {
        let parameter = TextFormDataParameter(name: "", value: "value")
        XCTAssertNil(parameter.formData(boundary: "boundary"))
    }
    
    func testEmptyValue() throws {
        let parameter = TextFormDataParameter(name: "name", value: "")
        XCTAssertNil(parameter.formData(boundary: "boundary"))
    }
    
    func testEmptyBoundary() throws {
        let parameter = TextFormDataParameter(name: "", value: "")
        XCTAssertNil(parameter.formData(boundary: ""))
    }
    
    func testValidData() throws {
        let parameter = TextFormDataParameter(name: "name", value: "value")
        let result = parameter.formData(boundary: "boundary")
        XCTAssertNotNil(result)
        let string = String(data: result!, encoding: .utf8)
        XCTAssertNotNil(string)
        XCTAssertEqual(string, "--boundary\r\nContent-Disposition: form-data; name=\"name\"\r\n\r\nvalue\r\n")
    }
}

