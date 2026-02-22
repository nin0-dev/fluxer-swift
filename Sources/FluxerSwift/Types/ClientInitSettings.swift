import NIO

public struct ClientInitSettings {
    let token: String
    let eventLoopGroup: EventLoopGroup

    public init(token: String, eventLoopGroup: EventLoopGroup) {
        self.token = token
        self.eventLoopGroup = eventLoopGroup
    }
}
