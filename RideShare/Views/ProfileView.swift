//
//  SwiftUIView.swift
//  RideShare
//
//  Created by Juan Sebastian Pedraza Perez on 21/03/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userSession: UserSession
    @ObservedObject private var viewModel = ProfileViewModel()
    @State private var isShowingImagePicker = false
    @State private var selectedTab = 0
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            Text("Descripción")
                .font(.title)
                .fontWeight(.bold)
                .tint(.black)
            HStack {
                Text("Name")
                    .font(.headline)
                Spacer()
                Text(".")
                    .font(.subheadline)
            }
            Divider()
            
            HStack {
                Text("Rating")
                    .font(.headline)
                Spacer()
                Text(".") // Format to one decimal place
                    .font(.subheadline)
            }
            Divider()
            
            HStack {
                Text("Billing")
                    .font(.headline)
                Spacer()
                Text(".")
                    .font(.subheadline)
            }
            Divider()
            
            Text("Mis vehiculos")
                .font(.title)
                .fontWeight(.bold)
                .tint(.black)
                .padding(.vertical,20)
            Spacer()
            
            HStack {
                Text("Type")
                    .font(.headline)
                Spacer()
                Text(".")
                    .font(.subheadline)
            }
            Divider()
            
            HStack {
                Text("Plate")
                    .font(.headline)
                Spacer()
                Text(".")
                    .font(.subheadline)
            }
            Divider()
            HStack {
                Text("Reference")
                    .font(.headline)
                Spacer()
                Text(".")
                    .font(.subheadline)
            }
            Divider()
            HStack {
                Text("Color")
                    .font(.headline)
                Spacer()
                Text(".") 
                    .font(.subheadline)
            }
            Divider()
            GreenButton(title: "Register new vehicle") {}
            
            
        }
        .padding(65)
        .padding(.vertical,-40)
        .onAppear {
            viewModel.fetchUser(byUID: userSession.uid ?? "defaultUID")
//            viewModel.fetchUser(byUID: userSession.uid!)
            
        }
    }
}



struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let userSession = UserSession()
                // Set any necessary properties on userSession here
                userSession.uid = "sampleUID"
                
                return ProfileView().environmentObject(userSession)
    }
}
