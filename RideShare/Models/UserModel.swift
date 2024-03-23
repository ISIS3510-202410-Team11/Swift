//
//  SwiftUIView.swift
//  RideShare
//
//  Created by Juan Sebastian Pedraza Perez on 21/03/24.
//

import Foundation
import UIKit
struct UserModel: Codable {
    var name: String
    var rating: Double
    var cedula: Int
    var paymentMethod: String
    var profileImage: Data? // Change UIImage to Data for storing in Firestore
}
