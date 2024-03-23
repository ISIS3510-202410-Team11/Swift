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
                        .fill(Color(.systemGray3))
                        .frame(width: 6, height: 6)
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 24)
                    Rectangle()
                        .fill(.black)
                        .frame(width: 6, height: 6)
                }
                VStack{
                    TextField("Current location", text: $startLocationText)
                        .frame(height: 32)
                        .background(Color(.systemGroupedBackground))
                        .padding(.trailing)
                    TextField("Where to?", text: $viewModel.queryFragment)
                        .frame(height: 32)
                        .background(Color(.systemGray4))
                        .padding(.trailing)
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
        .background(Color(.white))
    }
//        .navigationTitle("TITULO")
    }
}

#Preview {
    LocationSearchView()
}
