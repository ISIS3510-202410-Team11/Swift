//
//  ConnectivityManager.swift
//  RideShare
//
//  Created by Pablo Junco on 5/05/24.
//

import Foundation
import Network
import Combine

class ConnectivityManager: ObservableObject {
    static let shared = ConnectivityManager()
    @Published var isConnected = true
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "ConnectivityManager")

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
