//
//  ConnectivityBannerModifier.swift
//  RideShare
//
//  Created by Pablo Junco on 5/05/24.
//

import Foundation
import SwiftUI

struct OverlayConnectivityBanner: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(
                VStack {
                    ConnectivityBanner() // Your standalone banner view
                        .edgesIgnoringSafeArea(.all) // Optional, to cover the entire top edge including the safe area
//                    Spacer() // Pushes the banner to the top
                },
                alignment: .top // Aligns the overlay to the top of the content
            )
    }
}

extension View {
    func overlayConnectivityBanner() -> some View {
        self.modifier(OverlayConnectivityBanner())
    }
}
