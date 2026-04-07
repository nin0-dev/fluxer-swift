public struct UserPrivatePendingBulkMessageDeletion: Codable {
    public let channel_count: Int
    public let message_count: Int
    public let scheduled_at: String
}
