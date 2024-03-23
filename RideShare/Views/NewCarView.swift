//
//  NewCarView.swift
//  RideShare
//
//  Created by Pablo Junco on 22/03/24.
//

import Foundation
import SwiftUI
struct NewCarView: View {
    
    @EnvironmentObject var userSession: UserSession
    @StateObject var viewModel = NewCarViewModel()
    @State var navigateToProfileview = false
    
    var body: some View {
        
        NavigationView{
        VStack(spacing: 20) {
                        Text("Vehicle Form")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .tint(.black)
            
                        CustomTextField(title: "Type of vehicle", text: $viewModel.type).textFieldStyle(.plain)
            
                        CustomTextField(title: "Vehicle plate", text: $viewModel.plate, keyboardType: .emailAddress).textFieldStyle(.plain)
            
                        CustomTextField(title: "Vehicle reference", text: $viewModel.reference).textFieldStyle(.plain)
            
                        CustomTextField(title: "Vehicle color", text: $viewModel.color).textFieldStyle(.plain)
            
            
            
            
                        GreenButton(title: "Register new vehicle") {
                            
                            navigateToProfileview = true
                            
                            if let userUID = userSession.uid {
                                viewModel.registerVehicle(userUID: userUID)
                            } else {
                                viewModel.alertMessage = "User not logged in"
                                viewModel.showAlert = true
                            }
                        }
                        .disabled(!viewModel.isFormValid)
            
                    NavigationLink(destination: Tabvar(startingTab: .account), isActive: $navigateToProfileview) { EmptyView() }
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .alert(isPresented: $viewModel.showAlert) { // Use ViewModel's showAlert for binding
                        Alert(title: Text("Registration"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
                    }
        }
        
        
    }
    
    
}

struct NewCarView_Preview: PreviewProvider {
    static var previews: some View {
        // Create a temporary binding for isAuthenticated
        // For preview purposes, we initialize it with false
        NewCarView()
    }
}
