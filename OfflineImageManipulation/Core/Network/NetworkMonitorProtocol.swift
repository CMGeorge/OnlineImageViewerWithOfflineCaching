//
//  NetworkMonitorProtocol.swift
//  OfflineImageManipulation
//
//  Created by Calugar George on 03/09/2026.
//

enum NetworkConnectionType {
        case WiFi
        case Cellular
        case Wired
        case Unknown
        case None
}

protocol NetworkMonitorProtocol: AnyObject {
    
    var connected: Bool { get }
    var currentConnectionType: NetworkConnectionType { get }
    func start();
    func stop();
}
