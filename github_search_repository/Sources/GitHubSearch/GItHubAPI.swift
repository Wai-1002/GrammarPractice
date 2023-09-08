import Foundation

public final class GitHubAPI {
    public struct SearchRepositories : GitHubRequest {
        public let keyword: String
        
        public init(keyword: String) {
            self.keyword = keyword
        }
        
        // GitHubRequestが要求する連想型
        public typealias Response = SearchResponse<Repository>
        
        public var method: HTTPMethod {
            return .get
        }
        
        public var path: String {
            return "/search/repositories"
        }

        public var queryItems: [URLQueryItem] {
            return [URLQueryItem(name: "q", value: keyword)]
        }
    }
    
    public struct SearchUsers : GitHubRequest {
        public let keyword: String
        
        public init(keyword: String) {
            self.keyword = keyword
        }
        
        public typealias Response = SearchResponse<User>
        
        public var method: HTTPMethod {
            return .get
        }
        
        public var path: String {
            return "/search/users"
        }
        
        public var queryItems: [URLQueryItem] {
            return [URLQueryItem(name: "q", value: keyword)]
        }
    }
}
