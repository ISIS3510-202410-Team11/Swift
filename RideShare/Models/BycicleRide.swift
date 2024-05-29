//
//  BycicleRide.swift
//  RideShare
//
//  Created by Pablo Junco on 29/05/24.
//

import Foundation
struct BicycleRide: Identifiable {
    let id = UUID()
    let startLocation: String
    let startTime: String
    let endLocation: String
    let passengers: [String]
}
