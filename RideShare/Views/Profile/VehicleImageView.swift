//
//  VehicleImageView.swift
//  RideShare
//
//  Created by Pablo Junco on 24/04/24.
//

import Foundation
import SwiftUI

struct VehicleImageView: View {
    @StateObject private var loader = AsyncImageLoader()
    var vehicle: Vehicle
    var index: Int
    @ObservedObject var viewModel: ProfileViewModel
    
    var isSelected: Bool {
        viewModel.selectedVehicleIndex == index
    }
    
    var body: some View {
        ZStack {
            if let imageData = loader.imageData, let image = UIImage(data: imageData) {
                // If image data is available, display the image
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                // If image data is not available, display the vehicle type icon
                Image(vehicle.type.vehicleIconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .frame(width: 100, height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.green : Color.clear, lineWidth: 3)  // Conditional border color
        )
        .onAppear {
            if let urlString = vehicle.image, !urlString.isEmpty {
                loader.loadImage(from: urlString)
            }
        }
        .onChange(of: vehicle.image) { newImageUrl in
            if let newImageUrl = newImageUrl, !newImageUrl.isEmpty {
                loader.reset()
                loader.loadImage(from: newImageUrl)
            } else {
                loader.reset()
            }
        }
    }
}
