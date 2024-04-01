//
//  User.swift
//  RideShare
//
//  Created by Pablo Junco on 26/02/24.
//

import Foundation
import SwiftUI
struct UserProfile: Codable {
    var uid: String
    var name: String
    var email: String
    var driver: Bool
    var newsletter: Bool
    var rating : String?
    var payment : String?
    var profileImage: Data?
}
