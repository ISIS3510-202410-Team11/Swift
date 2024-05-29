//
//  Passenger.swift
//  RideShare
//
//  Created by Pablo Junco on 28/05/24.
//

import Foundation
struct Passenger: Identifiable {
    let id: String
    let name: String
    let email: String

    init?(dictionary: [String: Any]) {
        guard let id = dictionary["uid"] as? String,
              let name = dictionary["name"] as? String,
              let email = dictionary["email"] as? String else {
            return nil
        }
        self.id = id
        self.name = name
        self.email = email
    }
}
