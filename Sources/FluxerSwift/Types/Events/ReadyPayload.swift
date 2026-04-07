public struct ReadyPayload: Codable {
    public let version: Int
    public let session_id: String
    public let user: UserPrivate
}
