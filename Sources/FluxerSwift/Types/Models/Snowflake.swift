import Foundation

public struct Snowflake: Codable {
    public let rawValue: UInt64

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self), let value = UInt64(string) {
            rawValue = value
        } else {
            rawValue = try container.decode(UInt64.self)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        return try container.encode(String(rawValue))
    }

    public var createdAt: Date {
        Date(timeIntervalSince1970: Double((rawValue >> 22) + 1_420_070_400_000) / 1000)
    }
}
