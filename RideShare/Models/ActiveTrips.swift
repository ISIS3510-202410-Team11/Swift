//
//  ActiveTrips.swift
//  RideShare
//
//  Created by Cristian Caro on 4/05/24.
//

import Foundation

struct ActiveTrips: Decodable, Hashable, Encodable{
    var id: String
    var driver_id: String
    var end_location: String
    var passengers: [String]
    var route: [String]
    var start_location: String
    var start_time: String
}
