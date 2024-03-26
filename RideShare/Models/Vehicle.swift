//
//  Car.swift
//  RideShare
//
//  Created by Pablo Junco on 22/03/24.
//

import Foundation
import SwiftUI
struct Vehicle: Decodable, Hashable, Encodable {
    var type: String
    var plate: String
    var reference: String
    var color: String
}
