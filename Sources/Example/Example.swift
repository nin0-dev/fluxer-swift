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

        client.bus.sub(.closed) { (ec: CloseCode) in
            print("Closed with \(ec)")
            exit(1)
        }

        client.connect()
        dispatchMain()
    }
}
