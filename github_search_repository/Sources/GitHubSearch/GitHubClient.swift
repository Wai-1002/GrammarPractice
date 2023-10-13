import Foundation

public class GitHubClient {
    private let httpClient: HTTPClient
    
    public init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    public func send<Request : GitHubRequest>(
        request: Request,
        completion: @escaping (Result<Request.Response, GitHubClientError>) -> Void)
    {
        let urlRequest = request.buildURLRequest()
        
        httpClient.sendRequest(urlRequest) { result in
            switch result {
            case .success(let data, let urlResponse):
                do {
                    let response = try request.response(from: data, urlResponse: urlResponse)
                    completion(Result.success(response))
                } catch let error as GitHubAPIError {
                    completion(Result.failure(.apiError(error)))
                } catch {
                    completion(Result.failure(.responseParseError(error)))
                }
            case .failure(let error):
                completion(.failure(.connectionError(error)))
            }
        }
    }
}
