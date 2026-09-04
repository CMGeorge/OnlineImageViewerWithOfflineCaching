//
//  NetworkMonitorMock.swift
//  OfflineImageManipulation
//
//  Created by Calugar George on 04/09/2026.
//

@testable import OfflineImageManipulation

final class NetworkMonitorMock: NetworkMonitorProtocol {
    let connected: Bool

    let currentConnectionType: OfflineImageManipulation.NetworkConnectionType

    func start() {

    }

    func stop() {

    }
    init(connected: Bool) {
        self.connected = connected
        self.currentConnectionType = .Cellular
    }

}
