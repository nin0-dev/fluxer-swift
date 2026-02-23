public struct UpdatePresenceObject: Codable {
    var afk: Bool?
    var custom_status: CustomStatus?
    var mobile: Bool?
    var status: String
}
