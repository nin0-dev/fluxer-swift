import NIOWebSocket
import WebSocketKit

public enum CloseCode: Int {
    case unknownError = 4000
    case unknownOpcode = 4001
    case decodeError = 4002
    case notAuthenticated = 4003
    case authenticationFailed = 4004
    case alreadyAuthenticated = 4005
    case invalidSeq = 4007
    case rateLimited = 4008
    case sessionTimeout = 4009
    case invalidShard = 4010
    case shardingRequired = 4011
    case invalidAPIVersion = 4012
}

extension CloseCode {
    init?(webSocketErrorCode: WebSocketErrorCode) {
        switch webSocketErrorCode {
            case .unknown(let code):
                self.init(rawValue: Int(code))
            default:
                return nil
        }
    }
}
