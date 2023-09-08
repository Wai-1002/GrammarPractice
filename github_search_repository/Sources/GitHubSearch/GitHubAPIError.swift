public struct GitHubAPIError : Decodable, Error {
    public struct Error : Decodable {
        public var resource: String
        public var field: String
        public var code: String
    }
    public var message: String
    public var errors: [Error]
}
