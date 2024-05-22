//
//  LocationSearchView.swift
//  RideShare
//
//  Created by Cristian Caro on 22/03/24.
//

import SwiftUI

struct LocationSearchView: View {
    @State private var startLocationText = ""
    @State private var previousQueryFragment = ""
    @State private var showAlert = false
    @Binding var mapState: MapViewState
    @ObservedObject var networkManager = NetworkManager()
    @EnvironmentObject var viewModel: LocationSearchViewModel

    var body: some View {
        NavigationView{
            VStack{
                //Header
                HStack{
                    
                    VStack{
                        Circle()
                            .fill(Color(.red))
                            .frame(width: 6, height: 6)
                            
                        Rectangle()
                            .fill(Color(.black))
                            .frame(width: 1, height: 24)
                        Rectangle()
                            .fill(Color.green)
                            .frame(width: 6, height: 6)
                    }
                    
                    VStack{
                        TextField("  Current location", text: $startLocationText)
                            .frame(height: 32)
                            .background(Color(.systemGroupedBackground))    
                            .cornerRadius(15)
                            .overlay(
                                    RoundedRectangle(cornerRadius: 20) // Match the corner radius with the fill
                                        .stroke(Color.black, lineWidth: 1) // Apply stroke as overlay
                                )
                            .padding(.bottom)
                            .disabled(true) //no editable
                        
                        TextField("  Where to?", text: $viewModel.queryFragment)
                            .frame(height: 32)
                            .background(Color(.systemGroupedBackground))
                            .cornerRadius(15)
                            .overlay(
                                    RoundedRectangle(cornerRadius: 20) // Match the corner radius with the fill
                                        .stroke(Color.green, lineWidth: 1) // Apply stroke as overlay
                                )
                            .onTapGesture {
                                if !networkManager.isConnected {
                                    //print("DEBUG: NO INTERNET")
                                    showAlert = true
                                }
                            }
                            // Alert shown when there is no internet
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("There is not connection to internet"),
                                    message: Text("The search cannot be done because there is no internet connection."),
                                    dismissButton: .default(Text("Accept"))
                                )
                            }
                    }
                }
                .padding(.horizontal)
                .padding(.top,64)

                Divider()
                    .padding(.vertical)
                //list
                ScrollView{
                    VStack(alignment: .leading){
                        ForEach(viewModel.results, id: \.self){
                            result in
                            LocationCell(
                                title: result.title,
                                subtitle: result.subtitle) //Object cell
                            .onTapGesture {
                                withAnimation(.spring()){
                                    if !networkManager.isConnected {
                                        
                                        showAlert = true
                                    } else {
                                        viewModel.selectLocation(result)
                                        mapState = .locationSelected
                                    }
                                }
                            }
                        }
                    }
                }
                //another alert for each element on the scroll view
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("There is not connection to internet"),
                        message: Text("Please check your internet connection and try again."),
                        dismissButton: .default(Text("Accept"))
                    )
                }
                //button
                NavigationLink(destination: SpeedView()){
                    Button{
                        AnalyticsManager.shared.logEvent(name: "BQ2.0", params: ["LocationDetailView":"Select Specific Location"])
                        AnalyticsManager.shared.logEvent(name: "User Navigates To CheckSpeed", params: ["SpeedView":"CheckSpeed Button"])
                        //remove in future
                        ClickCounter.shared.incrementCount()
                    }label:{
                        Text("Check speed")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 170, height: 48)
                            .background(.green)
                            .cornerRadius(12)
                    }
                }
            }
            .background(Color.clear)
    }
}
}

#Preview {
    LocationSearchView(mapState: .constant(.searchingForLocation))
}
