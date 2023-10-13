import Foundation
import XCTest
import GitHubSearch

class GitHubClientTests : XCTestCase {
    var httpClient: StubHTTPClient!
    var gitHubClient: GitHubClient!
    
    override func setUp() {
        super.setUp()
        httpClient = StubHTTPClient()
        gitHubClient = GitHubClient(httpClient: httpClient)
    }
    
    private func makeHTTPClientResult(statusCode: Int, json: String) -> Result<(Data, HTTPURLResponse), Error> {
        return .success((
            json.data(using: .utf8)!,
            HTTPURLResponse(
                url: URL(string: "https://api.github.com/search/repositories")!,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil)!
        ))
    }
    
    func testSuccess() {
        httpClient.result = makeHTTPClientResult(
            statusCode: 200,
            json: GitHubAPI.SearchRepositories.Response.exampleJSON)

        let request = GitHubAPI.SearchRepositories(keyword: "swift")
        let apiExpectation = expectation(description: "")
        gitHubClient.send(request: request) { result in
            switch result {
            case .success(let response):
                let repository = response.items.first
                XCTAssertEqual(repository?.fullName, "apple/swift")
            default:
                XCTFail("unexpected result: \(result)")
            }
            apiExpectation.fulfill()
        }
        
        wait(for: [apiExpectation], timeout: 3)
    }
    
    func testFailureByConnectionError() {
        httpClient.result = .failure(URLError(.cannotConnectToHost))
        
        let request = GitHubAPI.SearchRepositories(keyword: "swift")
        let apiExpectation = expectation(description: "")
        gitHubClient.send(request: request) { result in
            switch result {
            case .failure(.connectionError):
                break
            default:
                XCTFail("unexpected result: \(result)")
            }
            apiExpectation.fulfill()
        }
        
        wait(for: [apiExpectation], timeout: 3)
    }
    
    func testFailureByResponseParseError() {
        httpClient.result = makeHTTPClientResult(
            statusCode: 200,
            json: "{}")
        
        let request = GitHubAPI.SearchRepositories(keyword: "swift")
        let apiExpectation = expectation(description: "")
        gitHubClient.send(request: request) { result in
            switch result {
            case .failure(.responseParseError):
                break
            default:
                XCTFail("unexpected result: \(result)")
            }
            apiExpectation.fulfill()
        }
        
        wait(for: [apiExpectation], timeout: 3)
    }
    
    func testFailureByAPIError() {
        httpClient.result = makeHTTPClientResult(
            statusCode: 400,
            json: GitHubAPIError.exampleJSON)

        let request = GitHubAPI.SearchRepositories(keyword: "")
        let apiExpectation = expectation(description: "")
        gitHubClient.send(request: request) { result in
            switch result {
            case .failure(.apiError(let error)):
                XCTAssertEqual(error.message, "Validation Failed")
            default:
                XCTFail("unexpected result: \(result)")
            }
            apiExpectation.fulfill()
        }
        
        wait(for: [apiExpectation], timeout: 3)
    }
}
