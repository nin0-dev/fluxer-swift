public struct DispatchEvent<D: Codable>: GatewayEvent {
    public var op: Opcode = .dispatch
    public let d: D
    public let t: String
    public let s: Int
}
