//
//  LocalPaymentMethods.swift
//  RideShare
//
//  Created by Cristian Caro on 24/04/24.
//

import Foundation

struct Payment: Equatable{
    var name: String
    var image: String
    var isFavorite: Bool
    
    static func preview() ->[Payment]{
        [Payment(name: "Nequi", image: "checkmark.seal", isFavorite: true),
        Payment(name: "Credit/Debit Card", image: "hare", isFavorite: false),
        Payment(name: "PayPal", image: "tv.circle", isFavorite: true)]
    }
}
