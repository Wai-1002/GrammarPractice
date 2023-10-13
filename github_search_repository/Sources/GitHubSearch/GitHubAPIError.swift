public struct GitHubAPIError : Decodable, Error {
    public struct Error : Decodable {
        public let resource: String
        public let field: String
        public let code: String
    }
    public var message: String
    public var errors: [Error]
}
