public protocol GatewayEvent: Codable {
    associatedtype Data: Codable

    static var op: Int { get }

    var op: Int { get }
    var d: Data? { get }
    var s: Int? { get }
    var t: String? { get }
}

extension GatewayEvent {
    public var op: Int { Self.op }
    public var s: Int? { nil }
    public var t: String? { nil }
}
