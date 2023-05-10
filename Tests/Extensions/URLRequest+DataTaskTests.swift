import XCTest
import Mocker
@testable import NetworkExtensions

final class URLRequest_DataTaskTests: XCTestCase {
    
    struct Person: Codable {
        let name: String
    }
    
    private static var url: URL {
        URL(string: "https://api.server.com/")!
    }
    
    private var url: URL {
        Self.url
    }
    
    // MARK: - Setup / Tear Down
    
    override class func setUp() {
        guard let person = try? JSONEncoder().encode(Person(name: "John")) else { return }
        Mock(url: Self.url,
             dataType: .json,
             statusCode: 200,
             data: [
                .get: person
             ])
        .register()
    }
    
    override class func tearDown() {
        Mocker.removeAll()
    }
    
    // MARK: - Closure
    
    func testCreateRequestClosureDataTask() throws {
        let task = URLRequest(url: url).dataTask(autoResume: false)
        XCTAssertEqual(task.state, .suspended)
    }
    
    func testExecuteRequestClosureDataTask() throws {
        let testExpectation = expectation(description: "Task will be executed")
        var executed = false
        let task = URLRequest(url: url).dataTask { _, _, _ in
            executed = true
            testExpectation.fulfill()
        }
        XCTAssertEqual(task.state, .running)
        wait(for: [testExpectation], timeout: 1)
        XCTAssertTrue(executed)
    }
    
    func testExecuteRequestClosureDataTaskWithResponseType() throws {
        let testExpectation = expectation(description: "Task will be executed")
        var executed = false
        let task = URLRequest(url: url).dataTask(waitingFor: Person.self) { person, error in
            XCTAssertEqual(person?.name, "John")
            XCTAssertNil(error)
            executed = true
            testExpectation.fulfill()
        }
        XCTAssertEqual(task.state, .running)
        wait(for: [testExpectation], timeout: 1)
        XCTAssertTrue(executed)
    }
    
    func testExecuteRequestClosureDataTaskWithResponseTypeError() throws {
        let testExpectation = expectation(description: "Task will be executed")
        var executed = false
        let task = URLRequest(url: URL(string: "///")!).dataTask(waitingFor: String.self) { person, error in
            XCTAssertNil(person)
            XCTAssertNotNil(error)
            executed = true
            testExpectation.fulfill()
        }
        XCTAssertEqual(task.state, .running)
        wait(for: [testExpectation], timeout: 1)
        XCTAssertTrue(executed)
    }
    
    func testExecuteRequestClosureDataTaskWithResponseTypeFailure() throws {
        let testExpectation = expectation(description: "Task will be executed")
        var executed = false
        let task = URLRequest(url: url).dataTask(waitingFor: String.self) { person, error in
            XCTAssertNil(person)
            XCTAssertNotNil(error)
            XCTAssertEqual(error as? NetworkingError, .couldNotDecodeResponseData)
            executed = true
            testExpectation.fulfill()
        }
        XCTAssertEqual(task.state, .running)
        wait(for: [testExpectation], timeout: 1)
        XCTAssertTrue(executed)
    }
    
    // MARK: - Async/Await
    
    @available(macOS 12.0, *)
    @available(iOS 15.0, *)
    func testExecuteRequestAsyncDataTask() async throws {
        let (data, response) = try await URLRequest(url: url).send()
        XCTAssertNotNil(data)
        XCTAssertNotNil(response)
    }
    
    @available(macOS 12.0, *)
    @available(iOS 15.0, *)
    func testExecuteRequestAsyncDataTaskWithResponseType() async throws {
        let person = try await URLRequest(url: url).send(waitingFor: Person.self)
        XCTAssertNotNil(person)
        XCTAssertEqual(person.name, "John")
    }
    
    @available(macOS 12.0, *)
    @available(iOS 15.0, *)
    func testExecuteRequestAsyncDataTaskWithResponseTypeFailure() async throws {
        do {
            let _ = try await URLRequest(url: url).send(waitingFor: String.self)
            XCTFail("Should not be here")
        } catch (let error) {
            XCTAssertNotNil(error)
            XCTAssertEqual(error as? NetworkingError, .couldNotDecodeResponseData)
        }
    }
}
