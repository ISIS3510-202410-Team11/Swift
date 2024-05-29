//
//  ServicesView.swift
//  RideShare
//
//  Created by Pablo Junco on 28/05/24.
//

import Foundation
import SwiftUI
struct ServicesView: View{
//    @State private var mapState = MapViewState.noInput

    var body: some View {
        NavigationView {
            VStack {
                // Card 1
                NavigationLink(destination: PublishedCommuteRoutesView()) {
                    CardComponent(
                        imageName: "image1",
                        titleText: "Published commute routes",
                        buttonText: "Search",
                        buttonAction: { }
                    )
                }
                .buttonStyle(PlainButtonStyle())
                // Card 2
                NavigationLink(destination: MapView()) {
                    CardComponent(
                        imageName: "image2",
                        titleText: "Begin a car-pool",
                        buttonText: "Publish",
                        buttonAction: { }
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
        }
    }
    }

struct ServicesView_Previews: PreviewProvider {
    static var previews: some View {
        ServicesView()
    }
}
