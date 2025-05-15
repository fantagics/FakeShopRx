//
//  NetworkMonitor.swift
//  FakeShop
//
//  Created by 이태형 on 1/18/25.
//

import Foundation
import Network

final class NetworkMonitor{
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    public private(set) var isConnected:Bool = false
    public private(set) var connectionType:ConnectionType = .unknown
    
    private init(){
        monitor = NWPathMonitor()
    }
    public func stopMonitoring(){
        monitor.cancel()
    }
    
    public func startMonitoring(){
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            print("[NM]Changed Network State. path:", path)
            self?.isConnected = path.status == .satisfied
            self?.getConenctionType(path)
            //네트워크 상태 변경될 때 마다 호출
            
            print(self?.isConnected ?? false ? "Network Connected" : "Network Disconnected")
            print("Network Conntexted Type:", self?.connectionType.str)
        }
    }
    
    private func getConenctionType(_ path:NWPath) {
        if path.usesInterfaceType(.wifi){
            connectionType = .wifi
        }else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        }else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        }else {
            connectionType = .unknown
        }
    }
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
        
        var str: String{
            switch self{
            case .wifi: return "wifi"
            case .cellular: return "cellular"
            case .ethernet: return "ethernet"
            default: return "unkown"
            }
        }
    }
    
}
