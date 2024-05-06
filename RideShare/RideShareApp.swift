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
    @StateObject var locationViewModel: LocationSearchViewModel
    let clickCounter = ClickCounter.shared
    // Firebase initialization
    init() {
        FirebaseApp.configure()
        _locationViewModel = StateObject(wrappedValue: LocationSearchViewModel()) 
    }
    
    
    
    var body: some Scene {
        
        WindowGroup {
            
            ContentView()
                .environmentObject(locationViewModel)
                .onAppear {
                    let startTime = DispatchTime.now()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        let endTime = DispatchTime.now()
                        let timeInterval = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000_000
                        ClickCounter.shared.getAppDeploymentTime(time: timeInterval)
                    }
                }
        }
    }
}
