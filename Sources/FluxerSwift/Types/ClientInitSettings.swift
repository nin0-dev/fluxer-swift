import NIO

public struct ClientInitSettings {
    let identify: IdentifyData
    let eventLoopGroup: EventLoopGroup

    public init(identify: IdentifyData, eventLoopGroup: EventLoopGroup) {
        self.identify = identify
        self.eventLoopGroup = eventLoopGroup
    }
}
