public struct SearchResponse<Item : Decodable> {
    public var totalCount: Int
    public var items: [Item]
    
    public enum CodingKeys : String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}
