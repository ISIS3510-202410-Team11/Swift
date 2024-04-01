//
//  OptionsButtonView.swift
//  RideShare
//
//  Created by Cristian Caro on 22/03/24.
//

import SwiftUI

struct OptionsButtonView: View {
    @Binding var showLocationSearchView: Bool

    var body: some View {
        Button{
            withAnimation(.spring()){
                showLocationSearchView.toggle()
            }
        } label: {
            Image(systemName: showLocationSearchView ?
                  "arrow.left" : "line.3.horizontal")
                .font(.title2)
                .foregroundColor(.green)
                .padding()
                .background(.white)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .overlay(
                    Circle() // Match the corner radius with the fill
                        .stroke(Color.green, lineWidth: 2) // Apply stroke as overlay
                )
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
    }
}

#Preview {
    OptionsButtonView(showLocationSearchView: .constant(true))
}
