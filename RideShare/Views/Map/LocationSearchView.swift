//
//  LocationSearchView.swift
//  RideShare
//
//  Created by Cristian Caro on 22/03/24.
//

import SwiftUI

struct LocationSearchView: View {
    @State private var startLocationText = ""
    @State private var endLocationText = ""
    @StateObject var viewModel = LocationSearchViewModel()

    var body: some View {
        NavigationView{
            VStack{
                //Header
                HStack{
                    
                    VStack{
                        Circle()
                            .fill(Color(.red))
                            .frame(width: 8, height: 15)
                            
                        Rectangle()
                            .fill(Color(.black))
                            .frame(width: 1, height: 30)
                        Rectangle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
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
                        
                            
                        TextField("  Where to?", text: $viewModel.queryFragment)
                            .frame(height: 32)
                            
                            .background(Color(.systemGroupedBackground))
                            .cornerRadius(15)
                            .overlay(
                                    RoundedRectangle(cornerRadius: 20) // Match the corner radius with the fill
                                        .stroke(Color.green, lineWidth: 1) // Apply stroke as overlay
                                )
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
                            NavigationLink(destination: RidePickerView()){
                                LocationCell(
                                    title: result.title,
                                    subtitle: result.subtitle) //Object cell
                            }
                        }
                    }
                }
                
                
                
                //button
                NavigationLink(destination: SpeedView()){
                    Text("Check speed")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 170, height: 48)
                        .background(.green)
                        .cornerRadius(12)

                }

            }
            .background(Color.clear)
    }
}
}

#Preview {
    LocationSearchView()
}
