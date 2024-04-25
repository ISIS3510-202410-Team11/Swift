//
//  LocationSearchView.swift
//  RideShare
//
//  Created by Cristian Caro on 22/03/24.
//

import SwiftUI

struct LocationSearchView: View {
    @State private var startLocationText = ""
    @Binding var mapState: MapViewState
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
                                            viewModel.selectLocation(result)
                                            mapState = .locationSelected
                                        }
                                }
                        }
                    }
                }
                //button
                NavigationLink(destination: SpeedView()){
                    Button{
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
