import Foundation
import NIO
import WebSocketKit

public final class FluxerClient: @unchecked Sendable {
    private let token: String
    private let elg: EventLoopGroup
    private var webSocket: WebSocket?

    public init(_ settings: ClientInitSettings) {
        self.token = settings.token
        self.elg = settings.eventLoopGroup
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
            }
        }
    }
}
