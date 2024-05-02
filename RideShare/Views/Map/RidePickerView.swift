//
//  RidePickerView.swift
//  RideShare
//
//  Created by Cristian Caro on 22/03/24.
//

import SwiftUI

struct RidePickerView: View {
    let drivers = driverslist
    @Binding var mapState: MapViewState
    @State private var showAlert = false
    @ObservedObject var networkManager = NetworkManager()
    
    var body: some View {
        VStack{
            Text("Choose your prefered ride")
                .fontWeight(.bold)
                .foregroundColor(.black)
            Divider()
            ScrollView{
                LazyVStack{
                    ForEach(0 ... 10, id:\.self){ cell in
                        RidePickerCell()
                            .onTapGesture {
                                if !networkManager.isConnected {
                                    // Show alert will occur
                                    //print("DEBUG: NO INTERNET")
                                    showAlert = true
                                } else {
                                    showAlert = false
                                    actionState(mapState)
                                }
                            }
                    }
                }
            }
            .refreshable {
                print("DEBUG: refresh")
            }
            //another alert for each element on the scroll view
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("There is not connection to internet"),
                    message: Text("Please check your internet connection and try again."),
                    dismissButton: .default(Text("Accept"))
                )
            }
        }
        .background(Color.white)

    }
    func actionState(_ state: MapViewState){
        if state == .rideOffers{
            mapState = .payment
        }
    }
    
}

#Preview {
    RidePickerView(mapState: .constant(.rideOffers))
    
}
