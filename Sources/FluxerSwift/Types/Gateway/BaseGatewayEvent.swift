public struct BaseGatewayEvent: Decodable {
    let op: Opcode
    let s: Int?
}
