import Foundation
import Network

@MainActor
protocol NetworkMonitoring: AnyObject {
    var isConnected: Bool { get }
}

@MainActor
@Observable
final class NetworkMonitor: NetworkMonitoring {
    private let monitor: NWPathMonitor
    private let queue: DispatchQueue

    private(set) var isConnected = true

    init(
        monitor: NWPathMonitor = NWPathMonitor(),
        queue: DispatchQueue = DispatchQueue(label: "com.converter.network-monitor")
    ) {
        self.monitor = monitor
        self.queue = queue

        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
