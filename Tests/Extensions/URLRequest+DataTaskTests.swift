import XCTest
@testable import NetworkExtensions

final class URLRequest_DataTaskTests: XCTestCase {
    
    private var url: URL {
        URL(string: "https://google.com/")!
    }
    
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
    
    @available(iOS 15.0, *)
    func testExecuteRequestAsyncDataTask() async throws {
        let (data, response) = try await URLRequest(url: url).send()
        XCTAssertNotNil(data)
        XCTAssertNotNil(response)
    }
}
