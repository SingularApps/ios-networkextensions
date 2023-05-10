import XCTest
@testable import NetworkExtensions

final class Data_ConversionsTests: XCTestCase {

    // MARK: - Int Value
    
    func testIntValueEmpty() throws {
        let data = Data()
        let value = data.intValue
        XCTAssertNil(value)
    }
    
    func testIntValueInvalid() throws {
        let data = "test".data(using: .unicode)!
        let value = data.intValue
        XCTAssertNil(value)
    }
    
    func testIntValueValid() throws {
        let data = "15".data(using: .utf8)!
        let value = data.intValue
        XCTAssertEqual(value, 15)
    }
    
    // MARK: - Float Value
    
    func testFloatValueEmpty() throws {
        let data = Data()
        let value = data.floatValue
        XCTAssertNil(value)
    }
    
    func testFloatValueInvalid() throws {
        let data = "test".data(using: .unicode)!
        let value = data.floatValue
        XCTAssertNil(value)
    }
    
    func testFloatValueValid() throws {
        let data = "15.73".data(using: .utf8)!
        let value = data.floatValue
        XCTAssertEqual(value, Float(15.73))
    }
    
    // MARK: - Double Value
    
    func testDoubleValueEmpty() throws {
        let data = Data()
        let value = data.doubleValue
        XCTAssertNil(value)
    }
    
    func testDoubleValueInvalid() throws {
        let data = "test".data(using: .unicode)!
        let value = data.doubleValue
        XCTAssertNil(value)
    }
    
    func testDoubleValueValid() throws {
        let data = "15.73".data(using: .utf8)!
        let value = data.doubleValue
        XCTAssertEqual(value, Double(15.73))
    }
    
    // MARK: - Array Value
    
    func testArrayValueEmpty() throws {
        let data = Data()
        let value = data.arrayValue
        XCTAssertNil(value)
    }
    
    func testArrayValueInvalid() throws {
        let data = "test".data(using: .unicode)!
        let value = data.arrayValue
        XCTAssertNil(value)
    }
    
    func testArrayValueValid() throws {
        let array: [Int] = [1, 2, 3]
        let data = try JSONSerialization.data(withJSONObject: array)
        let value = data.arrayValue
        XCTAssertEqual(value as? [Int], array)
    }
    
    // MARK: - Dictionary Value
    
    func testDictionaryValueEmpty() throws {
        let data = Data()
        let value = data.dictionaryValue
        XCTAssertNil(value)
    }
    
    func testDictionaryValueInvalid() throws {
        let data = "test".data(using: .unicode)!
        let value = data.dictionaryValue
        XCTAssertNil(value)
    }
    
    func testDictionaryValueValid() throws {
        let dictionary: [String: Any] = [
            "name": "John"
        ]
        let data = try JSONSerialization.data(withJSONObject: dictionary)
        let value = data.dictionaryValue
        XCTAssertEqual(value?["name"] as? String, "John")
    }
    
    // MARK: - String Value
    
    func testStringValueEmpty() throws {
        let data = Data()
        let value = data.stringValue
        XCTAssertEqual(value, "")
    }
    
    func testStringValueInvalid() throws {
        let data = "test".data(using: .unicode)!
        let value = data.stringValue()
        XCTAssertNil(value)
    }
    
    func testStringValueValid() throws {
        let data = "test".data(using: .utf8)!
        let value = data.stringValue()
        XCTAssertEqual(value, "test")
    }
    
    func testStringValueValidWithAlternateEncoding() throws {
        let data = "test".data(using: .utf16)!
        let value = data.stringValue(encoding: .utf16)
        XCTAssertEqual(value, "test")
    }
    
    // MARK: - JSON Value
    
    private struct Person: Codable {
        let name: String
        let age: Int
    }
    
    func testJSONValueEmpty() throws {
        let data = Data()
        let value: Person? = data.jsonObject()
        XCTAssertNil(value)
    }
    
    func testJSONValueInvalid() throws {
        let data = "test".data(using: .unicode)!
        let value: Person? = data.jsonObject()
        XCTAssertNil(value)
    }
    
    func testJSONValueValid() throws {
        let data = try JSONEncoder().encode(Person(name: "John", age: 30))
        let value: Person? = data.jsonObject()
        XCTAssertEqual(value?.name, "John")
        XCTAssertEqual(value?.age, 30)
    }
}
