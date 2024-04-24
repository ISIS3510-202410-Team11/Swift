//
//  VehicleDetailsView.swift
//  RideShare
//
//  Created by Pablo Junco on 24/04/24.
//

import Foundation
import SwiftUI

struct VehicleDetailsView: View {
    var vehicle: Vehicle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ProfileTextFiles(label: "Type", value: vehicle.type)
            ProfileTextFiles(label: "Plate", value: vehicle.plate)
            ProfileTextFiles(label: "Referencia", value: vehicle.reference)
            ProfileTextFiles(label: "Color", value: vehicle.color)
        }
        .padding(.horizontal)
    }
}

extension String {
    var vehicleIconName: String {
        switch self.lowercased() {
        case "car":
            return "icon-car"
        case "truck":
            return "icon-truck"
        case "motorcycle":
            return "icon-motorcycle"
        case "bicycle":
            return "icon-bicycle"
        default:
            return "icon-default"  // A default icon if no type matches
        }
    }
}
