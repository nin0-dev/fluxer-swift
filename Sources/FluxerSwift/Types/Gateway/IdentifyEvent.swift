public struct IdentifyProps: Codable {
    let os: String
    let browser: String
    let device: String
}

public struct IdentifyData: Codable {
    let token: String
    let properties: IdentifyProps?
    let presence: UpdatePresenceObject?

    public init(
        token: String, properties: IdentifyProps? = nil, presence: UpdatePresenceObject? = nil
    ) {
        self.token = token
        self.properties =
            properties
            ?? .init(
                os: OS, browser: "fluxer-swift", device: "fluxer-swift")
        self.presence =
            presence
            ?? .init(
                status: "online"
            )
    }
}

public struct IdentifyEvent: GatewayEvent {
    public var op: Opcode = .identify
    public let d: IdentifyData

    public init(data: IdentifyData) {
        self.d = data
    }
}
