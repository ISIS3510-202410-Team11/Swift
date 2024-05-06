//
//  ConnectivityBanner.swift
//  RideShare
//
//  Created by Pablo Junco on 5/05/24.
//

import Foundation
import SwiftUI

struct ConnectivityBanner: View {
    @ObservedObject var connectivityManager = ConnectivityManager.shared

    var body: some View {
        Group {
            if !connectivityManager.isConnected {
                Text("No Internet Connection")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 80)
                    .background(Color.red)
                    .transition(.move(edge: .top))
            }
        }
    }
}
