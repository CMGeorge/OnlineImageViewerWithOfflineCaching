//
//  NetworkMonitor.swift
//  OfflineImageManipulation
//
//  Created by Calugar George on 03/09/2026.
//

// NWPathMonitor - https://developer.apple.com/documentation/network/nwpathmonitor
import Network

//make it observable because we need real time status change

//make it observable
import Observation
@Observable
class NetworkMonitor: NetworkMonitorProtocol {

    //allow extenrnal read and no modification (read only properties)
    private(set) var connected: Bool = true
    private(set) var currentConnectionType: NetworkConnectionType = .WiFi

    private let monitor: NWPathMonitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "OIM.network.monitor")

    //Lifecicle
    init() {

        //decision should be take if we need to auto start or not
        start()
        //quick update the state at init
        update(monitor.currentPath)

    }
    deinit {
        monitor.cancel()
    }
    func start() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                self?.update(path)
            }
        }
        monitor.start(queue: queue)
    }
    func stop() {
        monitor.cancel()
    }
    private func update(_ path: NWPath) {
        self.connected = path.status == .satisfied
        currentConnectionType = {
            if path.status != .satisfied { return .None }
            if path.usesInterfaceType(.wifi) { return .WiFi }
            if path.usesInterfaceType(.cellular) { return .Cellular }
            if path.usesInterfaceType(.wiredEthernet) { return .Wired }
            return .Unknown
        }()

    }
}
