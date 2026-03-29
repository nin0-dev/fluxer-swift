public struct EmptyData: Codable {}

public protocol GatewayEvent: Codable {
    associatedtype D: Codable

    var op: Opcode { get }
    var d: D { get }
    var s: Int? { get }
    var t: String? { get }
}

extension GatewayEvent {
    public var s: Int? { nil }
    public var t: String? { nil }
}
