//
//  RidePickerCell.swift
//  RideShare
//
//  Created by Cristian Caro on 24/04/24.
//

import SwiftUI

struct RidePickerCell: View {
    var body: some View {
        VStack {
            HStack{
                Image(systemName: "car")
                    .resizable()
                    .foregroundColor(.black)
                    .accentColor(.white)
                    .frame(width: 40, height: 40)
                VStack{
                    Text("Placa")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    Text("Marca")
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.black)
                    Text("3:30pm")
                        .font(.footnote)
                        .foregroundColor(.black)
                }
                .padding(.leading, 8)
                .padding(.vertical, 8)
                
                Spacer()
                
                Text("$4.000")
                    .font(.footnote)
                    .foregroundColor(.black)
                    .padding()
                Image(systemName: "arrow.right")
                    .foregroundColor(.black)
                    .padding()
            }
            .padding(.leading)
        }
        Divider()
    }
}

#Preview {
    RidePickerCell()
}
