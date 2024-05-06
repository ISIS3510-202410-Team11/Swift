//
//  ContentView.swift
//  RideShare
//
//  Created by Pablo Junco on 26/02/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        RegistrationView()
            .overlayConnectivityBanner()
            .onAppear {
                print("Current connectivity status: \(ConnectivityManager.shared.isConnected)")
            }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
