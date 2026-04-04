import FluxerSwift
import Foundation
import NIO

let elg = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
let client = FluxerClient(
    .init(
        identify: .init(token: TOKEN),
        eventLoopGroup: elg
    )
)

client.onClose = { ec in
    print("Closed with \(ec)")
    exit(1)
}

client.connect()

dispatchMain()
