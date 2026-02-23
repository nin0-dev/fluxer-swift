import Foundation
import NIO
import WebSocketKit

public final class FluxerClient: @unchecked Sendable {
    private let identify: IdentifyData
    private let encoder = JSONEncoder()
    private let elg: EventLoopGroup
    private var webSocket: WebSocket?

    public init(_ settings: ClientInitSettings) {
        self.identify = settings.identify
        self.elg = settings.eventLoopGroup
    }

    public func send(_ event: any GatewayEvent) async throws {
        let data = try encoder.encode(event)
        let json = String(data: data, encoding: .utf8)!
        print(json)
        try await self.webSocket!.send(json)
    }

    public func connect() {
        _ = WebSocket.connect(
            to: FLUXER_GATEWAY_URL,
            on: elg
        ) { [weak self] ws in
            guard let self = self else { return }
            self.webSocket = ws
            print("Connected to Fluxer WS")

            ws.onText { ws, text in
                print("Received text:", text)
                Task {
                    try! await self.send(
                        IdentifyEvent(
                            data: self.identify
                        ))
                }
            }
        }
    }
}
