import Foundation
import NIO
import WebSocketKit

public final class FluxerClient: @unchecked Sendable {
    private let identify: IdentifyData
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let elg: EventLoopGroup
    private var webSocket: WebSocket?
    private var isHeartbeatAcknowledged = true
    public var onClose: ((CloseCode) -> Void)?

    public init(_ settings: ClientInitSettings) {
        self.identify = settings.identify
        self.elg = settings.eventLoopGroup
    }

    public func send(_ event: inout any GatewayEvent) async throws {
        let data = try encoder.encode(event)
        let json = String(data: data, encoding: .utf8)!
        try await self.webSocket!.send(json)
    }

    public func connect() {
        _ = WebSocket.connect(
            to: FLUXER_GATEWAY_URL,
            on: elg
        ) { [weak self] ws in
            guard let self = self else { return }
            self.webSocket = ws
            print("Connected to Fluxer Gateway")

            ws.onClose.whenSuccess {
                guard
                    let fn = self.onClose,
                    let closeCode = self.webSocket?.closeCode
                else { return }
                switch closeCode {
                    case .init(codeNumber: CloseCode.unknownError.rawValue):
                        fn(.unknownError)
                    case .init(codeNumber: CloseCode.unknownOpcode.rawValue):
                        fn(.unknownOpcode)
                    case .init(codeNumber: CloseCode.decodeError.rawValue):
                        fn(.decodeError)
                    case .init(codeNumber: CloseCode.notAuthenticated.rawValue):
                        fn(.notAuthenticated)
                    case .init(codeNumber: CloseCode.authenticationFailed.rawValue):
                        fn(.authenticationFailed)
                    case .init(codeNumber: CloseCode.alreadyAuthenticated.rawValue):
                        fn(.alreadyAuthenticated)
                    case .init(codeNumber: CloseCode.invalidSeq.rawValue):
                        fn(.invalidSeq)
                    case .init(codeNumber: CloseCode.rateLimited.rawValue):
                        fn(.rateLimited)
                    case .init(codeNumber: CloseCode.sessionTimeout.rawValue):
                        fn(.sessionTimeout)
                    case .init(codeNumber: CloseCode.invalidShard.rawValue):
                        fn(.invalidShard)
                    case .init(codeNumber: CloseCode.shardingRequired.rawValue):
                        fn(.shardingRequired)
                    case .init(codeNumber: CloseCode.invalidAPIVersion.rawValue):
                        fn(.invalidAPIVersion)
                    default:
                        return
                }
            }

            ws.onText { ws, text in
                do {
                    let d = text.data(using: .utf8)!
                    let baseEvent = try self.decoder.decode(
                        BaseGatewayEvent.self, from: d)
                    switch baseEvent.op {
                        case .hello:
                            let event = try self.decoder.decode(HelloEvent.self, from: d)
                            Task {
                                try await self.send(IdentifyEvent(data: self.identify))
                                try await Task.sleep(
                                    for: .milliseconds(
                                        Double(event.d.heartbeat_interval)
                                            + Double.random(in: 0.0...1.0))
                                )
                                try await self.send(HeartbeatEvent())
                            }
                        default:
                            print(
                                "Unimplemented opcode \(baseEvent.op) (\(baseEvent.op.rawValue)), please report this"
                            )
                    }
                } catch {
                    print("Gateway handling error: \(error)")
                }
            }
        }
    }
}
