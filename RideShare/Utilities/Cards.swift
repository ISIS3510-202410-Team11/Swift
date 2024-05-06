//
//  Cards.swift
//  RideShare
//
//  Created by Pablo Junco on 5/05/24.
//

import Foundation
import SwiftUI

struct CardComponent: View {
    var imageName: String
    var titleText: String
    var buttonText: String
    var buttonAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(imageName) // Using the parameter for the image name
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .clipped()
            Text(titleText) // Using the parameter for the title
                .font(.headline)
                .padding(.leading)
            Button(action: buttonAction) { // Using the parameter for the button action
                Text(buttonText) // Using the parameter for the button text
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal, 40)
        .padding(.vertical, 40)
    }
}
