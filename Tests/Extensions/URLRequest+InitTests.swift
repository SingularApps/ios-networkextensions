import XCTest
@testable import NetworkExtensions

final class URLRequest_InitTests: XCTestCase {
    
    func testCreateRequestWithInvalidURL() throws {
        do {
            _ = try URLRequest(stringUrl: "\\\\\\")
            XCTFail("Should not be here")
        } catch (let error) {
            let networkingError = error as? NetworkingError
            XCTAssertNotNil(networkingError)
            XCTAssertEqual(networkingError, NetworkingError.invalidURL)
        }
    }
    
    func testCreateRequestWithValidURL() throws {
        let request = try URLRequest(stringUrl: "https://api.server.com/")
        XCTAssertNotNil(request)
        XCTAssertEqual(request.url?.absoluteString, "https://api.server.com/")
    }
}
