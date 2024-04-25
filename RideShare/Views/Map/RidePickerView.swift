//
//  RidePickerView.swift
//  RideShare
//
//  Created by Cristian Caro on 22/03/24.
//

import SwiftUI

struct RidePickerView: View {
    let drivers = driverslist
    //@Binding var mapState: MapViewState
    
    var body: some View {
        NavigationStack{
            ScrollView{
                LazyVStack{
                    ForEach(0 ... 10, id:\.self){ cell in
                        NavigationLink(destination: PaymentView()){
                            RidePickerCell()
                        }
                    }
                }
            }
            .refreshable {
                print("DEBUG: refresh")
            }
            .navigationTitle("Available Rides")
            .navigationBarTitleDisplayMode(.inline)
        }
        //IT IS NOT SHOWN VIA REAL PHONE, UPDATE THIS MF
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button {
                    ClickCounter.shared.incrementCount()
                } label:{
                    Image(systemName: "arrow.counterclockwise")
                        .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    RidePickerView()
    
}
