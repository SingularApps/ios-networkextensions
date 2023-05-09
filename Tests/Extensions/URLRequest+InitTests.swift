import XCTest
@testable import NetworkExtensions

final class URLRequest_InitTests: XCTestCase {
    
    override class func setUp() {
        URLRequest.baseUrl = "https://api.server.com/"
    }
    
    func testCreateRequestWithInvalidURL() throws {
        do {
            _ = try URLRequest(endpoint: "\\\\\\")
            XCTFail("Should not be here")
        } catch (let error) {
            let networkingError = error as? NetworkingError
            XCTAssertNotNil(networkingError)
            XCTAssertEqual(networkingError, NetworkingError.invalidURL)
        }
    }
    
    func testCreateRequestWithBaseURL() throws {
        let request = try URLRequest()
        XCTAssertNotNil(request)
        XCTAssertEqual(request.url?.absoluteString, "https://api.server.com/")
    }
    
    func testCreateRequestWithStringEndpoint() throws {
        let request = try URLRequest(endpoint: "user")
        XCTAssertNotNil(request)
        XCTAssertEqual(request.url?.absoluteString, "https://api.server.com/user")
    }

    
    func testCreateRequestWithEndpointProtocol() throws {
        enum LoginAPI: Endpoint {
            case login
            case register
            
            var path: String {
                switch self {
                case .login: return "login"
                case .register: return "register"
                }
            }
        }
        let request1 = try URLRequest(endpoint: LoginAPI.login)
        XCTAssertNotNil(request1)
        XCTAssertEqual(request1.url?.absoluteString, "https://api.server.com/login")
        let request2 = try URLRequest(endpoint: LoginAPI.register)
        XCTAssertNotNil(request2)
        XCTAssertEqual(request2.url?.absoluteString, "https://api.server.com/register")
    }
}
