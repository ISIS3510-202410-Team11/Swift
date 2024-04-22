//
//  MapView.swift
//  RideShare
//
//  Created by Cristian Caro on 22/03/24.
//

import SwiftUI

struct MapView: View {
    @State private var showSearchView = false
    
    var body: some View {
        ZStack(alignment: .top) {
            MapRepresentable()
                .ignoresSafeArea()
            
            // Use HStack for horizontal layout of SearchBar and OptionsButton
            HStack(alignment: .top, spacing: 8) { // Adjust spacing as needed
                
                // OptionsButtonView on the left
                OptionsButtonView(showLocationSearchView: $showSearchView)
//                    .padding(.leading)
                    .padding(.top, 4)

                
                if showSearchView {
                    MapView()
                        .fullScreenCover(isPresented: $showSearchView, content: {
                            LocationSearchView()
                                .background(Color.white.opacity(0.5))
                                .edgesIgnoringSafeArea(.all)
                        })
                } else {
                    SearchBarView()
                        .onTapGesture {
                            withAnimation(.spring()) {
                                showSearchView.toggle()
                            }
                        }

                }
                
            }
            .padding(.top, 30)
            .padding(.horizontal,10)// Apply padding here to affect the whole HStack
            .padding([.leading, .trailing]) // Adjust horizontal paddings as needed
            
            Spacer()
        }
    }
}

#Preview {
    MapView()
}
