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
    
    // Firebase initialization
        init() {
            FirebaseApp.configure()
        }
    
    var userSession = UserSession()
        
    var body: some Scene {
        
        WindowGroup {

            ContentView()
                .environmentObject(userSession)

        }
    }
}
