import FluxerSwift
import Foundation
import NIO

@main
struct Example {
    static func main() {
        let elg = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        let client = FluxerClient(
            .init(
                identify: .init(token: TOKEN),
                eventLoopGroup: elg
            )
        )

        client.bus.sub(.ready) { (ec: ReadyPayload) in
            print(
                "Logged in as \(ec.user.tag) (\(ec.user.id.rawValue))"
            )
        }

        client.connect()
        dispatchMain()
    }
}
