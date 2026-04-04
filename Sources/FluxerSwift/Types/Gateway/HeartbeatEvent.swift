public struct HeartbeatEvent: GatewayEvent {
    public var op: Opcode = .heartbeat
    public let d: Int
}
