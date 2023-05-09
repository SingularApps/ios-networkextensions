import XCTest
@testable import NetworkExtensions

class FileFormDataParameterTests: XCTestCase {
    
    func testEmptyName() throws {
        let parameter = FileFormDataParameter(name: "", filename: "filename", contentType: "text/plain", data: Data())
        XCTAssertNil(parameter.formData(boundary: "boundary"))
    }
    
    func testEmptyFilename() throws {
        let parameter = FileFormDataParameter(name: "name", filename: "", contentType: "text/plain", data: Data())
        XCTAssertNil(parameter.formData(boundary: "boundary"))
    }
    
    func testEmptyContentType() throws {
        let parameter = FileFormDataParameter(name: "name", filename: "filename", contentType: "", data: Data())
        XCTAssertNil(parameter.formData(boundary: "boundary"))
    }
    
    func testEmptyBoundary() throws {
        let parameter = TextFormDataParameter(name: "", value: "")
        XCTAssertNil(parameter.formData(boundary: ""))
    }
    
    func testValidData() throws {
        let text = "some text".data(using: .utf8)!
        let parameter = FileFormDataParameter(name: "name", filename: "filename", contentType: "text/plain", data: text)
        let result = parameter.formData(boundary: "boundary")
        XCTAssertNotNil(result)
        let string = String(data: result!, encoding: .utf8)
        XCTAssertNotNil(string)
        XCTAssertEqual(string, "--boundary\r\nContent-Disposition: form-data; name=\"name\"; filename=\"filename\"\r\nContent-Type: \"text/plain\"\r\n\r\nsome text\r\n")
    }
}

