//
//  ContentView.swift
//  RideShare
//
//  Created by Pablo Junco on 26/02/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isAuthenticated = false

    var body: some View {
        if isAuthenticated {
            // Your app's main content or home screen
            Text("Welcome to the app!")
        } else {
            // Show LoginView if not authenticated
            RegistrationView(isAuthenticated: $isAuthenticated)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
