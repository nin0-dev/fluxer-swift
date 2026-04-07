import Foundation
import NIO
import WebSocketKit

public final class FluxerClient: @unchecked Sendable {
    private let identify: IdentifyData
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let elg: EventLoopGroup
    private var webSocket: WebSocket?
    private var sequenceNumber = 0
    private var isHeartbeatAcknowledged = true
    public let bus = EventBus()

    public init(_ settings: ClientInitSettings) {
        self.identify = settings.identify
        self.elg = settings.eventLoopGroup
    }

    private func send(_ event: any GatewayEvent) async throws {
        let data = try encoder.encode(event)
        let json = String(data: data, encoding: .utf8)!
        try await self.webSocket!.send(json)
    }

    private func decodePayload<P: Decodable>(_ type: P.Type, _ json: [String: Any]) throws -> P {
        return try self.decoder.decode(
            type,
            from: try JSONSerialization.data(
                withJSONObject: json["d"]!))
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
                    let closeCode = self.webSocket?.closeCode,
                    let code = CloseCode(webSocketErrorCode: closeCode)
                else { return }

                self.bus.pub(.closed, code)
            }

            ws.onText { ws, text in
                do {
                    let d = text.data(using: .utf8)!
                    let baseEvent = try self.decoder.decode(
                        BaseGatewayEvent.self, from: d)
                    if let seq = baseEvent.s {
                        self.sequenceNumber = seq
                    }
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
                                try await self.send(HeartbeatEvent(d: self.sequenceNumber))
                            }
                        case .heartbeat:
                            Task {
                                try await self.send(HeartbeatEvent(d: self.sequenceNumber))
                            }
                        case .dispatch:
                            let json =
                                try JSONSerialization.jsonObject(with: d) as! [String: Any]
                            Task {
                                if let event = Events(rawValue: json["t"] as! String) {
                                    switch event {
                                        case .closed:
                                            // this would never be called normally
                                            _ = 0
                                        case .ready:
                                            self.bus.pub(
                                                .ready,
                                                try self.decodePayload(ReadyPayload.self, json))
                                    }
                                } else {
                                    print(
                                        "Unknown event \(json["t"] as! String), report this."
                                    )
                                }
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
