public protocol GatewayEvent: Codable {
    associatedtype Data: Codable

    var op: Int { get }
    var d: Data? { get }
    var s: Int? { get }
    var t: String? { get }
}

extension GatewayEvent {
    public var s: Int? { nil }
    public var t: String? { nil }
}
