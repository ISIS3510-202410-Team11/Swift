//
//  RidePickerView.swift
//  RideShare
//
//  Created by Cristian Caro on 22/03/24.
//

import SwiftUI

struct RidePickerView: View {
    @Binding var mapState: MapViewState
    @State private var showAlert = false
    @ObservedObject var networkManager = NetworkManager()
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @ObservedObject private var viewModel: RidePickerViewModel = RidePickerViewModel()
    
    
    var body: some View {
        VStack{
            HStack{
                Text("Choose your prefered ride")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            Divider()
            if (viewModel.loadingBool){
                VStack{
                    Text("Loading Data ... ")
                        .font(.footnote)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.top, 10)
                }
            }
            if (viewModel.showAlert){
                VStack {
                    Spacer()
                    Text("There are no rides for the selected location at the moment, try again later")
                        .font(.footnote)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
            }
            ScrollView{
                LazyVStack{
                    ForEach(Array(viewModel.activeTrips.enumerated()), id: \.element){index, trip in
                        RidePickerCell(trip: trip, index: index)
                            .onTapGesture {
                                if !networkManager.isConnected {
                                    // Show alert will occur
                                    //print("DEBUG: NO INTERNET")
                                    showAlert = true
                                } else {
                                    showAlert = false
                                    locationViewModel.tripID = trip.id
                                    actionState(mapState)
                                }
                            }
                    }//end for each
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
        .onAppear {
            if let location = locationViewModel.selectedLocation{
                viewModel.updateSelectedLocation(location.title)
                viewModel.startCheckingDatabase()
            } else {
                Text("The location selected is not suitable, please try again")
                    .font(.subheadline)
            }
            
        }
        .onDisappear {
            viewModel.stopCheckingDatabase()
        }
        
    }
        
    

    func actionState(_ state: MapViewState){
        if state == .rideOffers{
            mapState = .payment
        }
    }
}

//#Preview {
//    RidePickerView(mapState: .constant(.rideOffers))
//}
