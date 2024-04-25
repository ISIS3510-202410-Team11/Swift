//
//  ClickService.swift
//  RideShare
//
//  Created by Cristian Caro on 24/04/24.
//

import Foundation

class ClickCounter {
    static let shared = ClickCounter() // Singleton
    
    private(set) var totalCount: Int = 0
    private(set) var ridesPayed: Int = 0
    private init() {} // Constructor is private so there is just 1 instance
    
    func incrementCount() {
        totalCount += 1
        print("DEBUG: NUMBER OF CLICKS IN ALL THE APP IS: \(totalCount)")
    }
    func incrementRidesPayed(){
        ridesPayed += 1
        print("DEBUG: NUMBER OF RIDES PAYED IS: \(ridesPayed)")
    }
}
