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

client.connect()

dispatchMain()
