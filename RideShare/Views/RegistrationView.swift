//
//  RegistrationView.swift
//  RideShare
//
//  Created by Pablo Junco on 26/02/24.
//

import Foundation
import SwiftUI
struct RegistrationView: View {

//    @StateObject private var registrationViewModel = RegistrationViewModel()
    @StateObject private var loginViewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack{
            GeometryReader { geometry in
                ZStack {
                    Image("RideShare")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.6)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    
                    VStack {
                        Spacer()
                        VStack(spacing: 20) {
                            
                            NavigationLink(destination: SignUpView()) {
                                GreenButton(title: "Sign Up") {
                                    // Trigger any additional actions
                                }
                            }
                            NavigationLink(destination: LoginView()) {
                                GreenButton(title: "Log In") {
                                    // Trigger any additional actions
                                }
                            }
                        }
                        .padding([.horizontal, .bottom])
                        
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    struct RegistrationView_Preview: PreviewProvider {
        static var previews: some View {
            // Create a temporary binding for isAuthenticated
            // For preview purposes, we initialize it with false
            RegistrationView()
        }
    }
    
    
}
