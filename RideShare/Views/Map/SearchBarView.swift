//
//  SearchBarView.swift
//  RideShare
//
//  Created by Cristian Caro on 22/03/24.
//

import SwiftUI

struct SearchBarView: View {
    var body: some View {
        HStack{
            Rectangle()
                .fill(Color.green)
                .frame(width: 8, height: 8)
                .padding(.horizontal)
                .cornerRadius(20)
            Text("Where to?")
                .foregroundColor(Color(.darkGray))
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 90, height: 50)
        .background(
            Rectangle()
                .fill(Color.white)
                .cornerRadius(15)
                .overlay(
                        RoundedRectangle(cornerRadius: 20) // Match the corner radius with the fill
                            .stroke(Color.green, lineWidth: 2) // Apply stroke as overlay
                    )
//                .shadow(color: .black,radius: 6)
        )
    }
}

#Preview {
    SearchBarView()
}
