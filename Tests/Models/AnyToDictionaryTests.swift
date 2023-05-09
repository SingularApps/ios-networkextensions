import XCTest
@testable import NetworkExtensions

final class AnyToDictionaryTests: XCTestCase {

    func testAnyToDictionaryInvalid() throws {
        let source = "test"
        do {
            let _ = try anyToDictionary(source)
            XCTFail("Statement should fail")
        } catch (let error) {
            XCTAssertNotNil(error)
            XCTAssertEqual(error as? CastingError, .invalidSource)
        }
    }
    
    func testAnyToDictionaryValid() throws {
        let source: [String: Any] = [
            "name": "John",
            "age": 30
        ]
        let dictionary = try anyToDictionary(source)
        XCTAssertEqual(dictionary["name"] as? String, "John")
        XCTAssertEqual(dictionary["age"] as? Int, 30)
    }
}
