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
                if let location = locationViewModel.selectedLocation{
                    Button{
                        viewModel.updateSelectedLocation(location.title)
                        //fetch data filtered
                        viewModel.fetchActiveTripsDataFiltered()
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            
            Divider()
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

    }
    func actionState(_ state: MapViewState){
        if state == .rideOffers{
            mapState = .payment
        }
    }
}

//#Preview {
//    RidePickerView(mapState: .constant(.rideOffers), locationViewModel: AnyClass)
//}
