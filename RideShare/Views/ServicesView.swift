//
//  ServicesView.swift
//  RideShare
//
//  Created by Pablo Junco on 5/05/24.
//

import Foundation
import SwiftUI
struct ServicesView: View{
    
    
    var body: some View {
            VStack {
                // Card 1
                CardComponent(
                            imageName: "image1",
                            titleText: "Published commute routes",
                            buttonText: "Search",
                            buttonAction: { print("Button Tapped") }
                        )

                // Card 2
                CardComponent(
                            imageName: "image2",
                            titleText: "Begin a car-pool",
                            buttonText: "publish",
                            buttonAction: { print("Button Tapped") }
                        )
            }
        }
    }

    struct Services_Preview: PreviewProvider {
        static var previews: some View {
            ServicesView()
        }
    }
