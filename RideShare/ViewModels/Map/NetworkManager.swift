//
//  NetworkManager.swift
//  RideShare
//
//  Created by Cristian Caro on 1/05/24.
//

import Foundation
import Network

class NetworkManager: ObservableObject{
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Network Manager")
    @Published var isConnected = true
    @Published var isConstrained = true
    @Published var isExpensive = true
    
    var imageName: String{
        if isConnected{
            return "wifi"
        } else{
            return "wifi.slash"
        }
    }
    var connectionDescription: String{
        if isConnected{
            return "Internet Connection looks good"
        } else{
            return "Looks like you are not connected"
        }
    }
    
    init(){
        monitor.pathUpdateHandler = {path in //makes a network request and gives a callback
            //status path determines network connection
            /*
            if path.status == .satisfied{
                self.isConnected = true
                
            } else{
                self.isConnected = false
            }
            */
            DispatchQueue.main.async { //do it in the main thread with async function
                self.isConnected = path.status == .satisfied   //an optimization to if statement
                //other functions
                self.isConstrained = path.isConstrained //if users has lowData mode on
                self.isExpensive = path.isExpensive //if user is on celular data
                //NWInterfaceType can check if the connection is wifi, ethernet, etc
            }
        }
        monitor.start(queue: queue) //starts the monitor and process it in the queue created
        //check if this consumes many resources or no
    }
}
