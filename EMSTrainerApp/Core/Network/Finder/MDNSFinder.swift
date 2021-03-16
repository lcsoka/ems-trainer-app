//
//  MDNSFinder.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 15..
//

import Foundation

class MDNSFinder:NSObject, FinderProtocol {
    
    var delegate: FinderDelegate?
    
    private var api: ApiService!
    private let netServiceBrowser = NetServiceBrowser()
    private var services:[NetService] = []
    
    init(api: ApiService) {
        super.init()
        self.api = api
        netServiceBrowser.delegate = self
    }
    
    func start() {
        stop()
        netServiceBrowser.searchForServices(ofType: "_http._tcp", inDomain: "")
    }
    
    func stop() {
        netServiceBrowser.stop()
    }
}

extension MDNSFinder: NetServiceBrowserDelegate, NetServiceDelegate {
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        if service.name.uppercased().contains("EMS") {
            services.append(service)
        }
        
        if moreComing == false {
            netServiceBrowser.stop()
        }
    }
    
    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        for service in services {
            let currentService = service
            currentService.delegate = self
            currentService.resolve(withTimeout: 5)
        }
    }
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        if let addresses = sender.addresses, addresses.count > 0 {
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            
            // The first address should be enough for us
            guard let data = sender.addresses?.first else { return }
            
            if getnameinfo((data as NSData).bytes.bindMemory(to: sockaddr.self, capacity: data.count), socklen_t(data.count),
                           &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                let ipAddress = String(cString: hostname)
               print(ipAddress)
                let resource = DeviceStatusResource(host: "http://\(ipAddress)")
                self.api.get(resource, params: nil, onSuccess: { response in
                    if let status = response {
                        self.delegate?.onDeviceFound(device: DeviceHost(address: ipAddress, deviceStatus: status))
                    }
                }) { _ in
                    
                }
            }
        }
    }
}
