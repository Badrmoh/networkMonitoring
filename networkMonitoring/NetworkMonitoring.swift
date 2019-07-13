//
//  NetworkMonitoring.swift
//  networkMonitoring
//
//  Created by Badr Ibrahim on 07.12.18.
//  Copyright © 2018 Badr Ibrahim. All rights reserved.
//

import Foundation
import UIKit
import Network
class NetworkMonitoring {
    
    private var _queue : DispatchQueue = DispatchQueue(label: "Network Monitoring Queue")
    //var connected : Bool
    private var _host : NWEndpoint.Host = "google.com"//"172.20.10.3"//"192.168.0.3"
    private var _port : NWEndpoint.Port = 443
    private var _prtcl : NWParameters = .tls
    private var _connection : NWConnection
    
    private var _color : UIColor = UIColor.lightGray
    
    
    private var _state : String?
    
    var host : NWEndpoint.Host {
        get {
            return self._host
        }
        set {
            self._host = host
        }
    }
    
    var port : NWEndpoint.Port {
        get {
            return self._port
        }
        set {
            self._port = port
        }
    }
    
    var prtcl : NWParameters {
        get {
            return self._prtcl
        }
        set {
            self._prtcl = prtcl
        }
    }
    
    var color : UIColor {
        get {
            return self._color
        }
    }
    
    var state : String {
        get {
            return _state ?? "No info"
        }
    }
   
    init(){self._connection = NWConnection(host: _host, port: _port, using: _prtcl);configConnection()}
    
    init?(host: NWEndpoint.Host, port: NWEndpoint.Port, prtcl: NWParameters, colorReady: UIColor, colorPreparing: UIColor, colorSetup : UIColor, colorWaiting : UIColor, colorFailed : UIColor, colorCancelled : UIColor) {
        
        self._host = host
        self._port = port
        self._prtcl = prtcl

        
        self._connection = NWConnection(host: host, port: port, using: prtcl)
        configConnection()
    }
    
    func getState() -> NWConnection.State{
        return self._connection.state
    }
    
    func startConnection(){
        
        self._connection.start(queue: self._queue)
        print("started")
    }
    
    func restartConnection(){
        if _state != "waiting" {
            //self._connection.start()
            print("not allowed")
        } else {
            self._connection.restart()
            print("restarted")
        }
    }
    
    func handleViability(block: @escaping (Bool)->Void){
        self._connection.viabilityUpdateHandler = block
    }
    
    func configConnection(){
        self._connection.stateUpdateHandler = { (newState) in
            switch newState {
            case .ready:
                print("connected")
                print(self._connection.debugDescription)
                self._state = "ready"
                self._color = UIColor.green
            case .preparing:
                print("preparing")
                print(self._connection.debugDescription)
                self._state = "preparing"
                self._color = UIColor.yellow
            case .setup:
                print("setup")
                print(self._connection.debugDescription)
                self._state = "setup"
                self._color = UIColor.purple
            case .waiting(let error):
                print("waiting")
                print("Waiting error ---- : \(error)")
                print(self._connection.debugDescription)
                self._state = "waiting"
                self._color = UIColor.orange
            case .failed(let error):
                print("failed")
                print("Failed error ---- : \(error)")
                print(self._connection.debugDescription)
                self._state = "failed"
                self._color = UIColor.red
            case .cancelled:
                print("connection teared down")
                print(self._connection.debugDescription)
                self._state = "cancelled"
                self._color = UIColor.lightGray
            }
        }
        
        self._connection.pathUpdateHandler = { path in
            if path.status == .satisfied {
            print("good")
            } else if path.status == .requiresConnection {
            print("Connection is required")
            } else {
            print("bad")
            }
        }
    }
}
