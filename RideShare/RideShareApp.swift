//
//  RideShareApp.swift
//  RideShare
//
//  Created by Pablo Junco on 26/02/24.
//

import SwiftUI   
import Firebase


@main
struct RideShareApp: App {
    @StateObject var locationViewModel = LocationSearchViewModel()
    // Firebase initialization
        init() {
            FirebaseApp.configure()
        }
    

        
    var body: some Scene {
        
        WindowGroup {

            //ContentView()
            MapView()
                .environmentObject(locationViewModel)

        }
    }
}
