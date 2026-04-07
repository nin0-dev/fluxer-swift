public struct PublicUserFlags: OptionSet, Codable, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(rawValue: try container.decode(Int.self))
    }

    static let staff = PublicUserFlags(rawValue: 1 << 0)
    static let ctpMember = PublicUserFlags(rawValue: 1 << 1)
    static let partner = PublicUserFlags(rawValue: 1 << 2)
    static let bugHunter = PublicUserFlags(rawValue: 1 << 3)
    static let friendlyBot = PublicUserFlags(rawValue: 1 << 4)
    static let friendlyBotManualApproval = PublicUserFlags(rawValue: 1 << 5)
}
