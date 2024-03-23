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
        ZStack(alignment: .top){
            
            MapRepresentable()
                .ignoresSafeArea()
            

            
            if showSearchView{
                LocationSearchView()
            }else{
                SearchBarView()
                    .padding(.top, 72)
                    .onTapGesture {
                        withAnimation(.spring()){
                            showSearchView.toggle()
                        }
                    }
            }
            OptionsButtonView(showLocationSearchView:$showSearchView)
                .padding(.leading)
                .padding(.top,4)
            
        }

    }
}

#Preview {
    MapView()
}
