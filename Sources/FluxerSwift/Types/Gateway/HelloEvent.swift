public struct HelloData: Codable {
    public let heartbeat_interval: Int
}

public struct HelloEvent: GatewayEvent {
    public var op: Opcode = .hello
    public let d: HelloData
}
