//
//  RidePickerView.swift
//  RideShare
//
//  Created by Cristian Caro on 22/03/24.
//

import SwiftUI

struct RidePickerView: View {
    let drivers = driverslist
    
    var body: some View {
        NavigationView{
            List{
                ForEach(drivers, id: \.self){ driver in
                    NavigationLink(destination: Text(driver)){
                        
                        HStack{
                            Image(systemName: "car")
                            
                            VStack{
                                Text(driver)
                                Text("3:30")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                            }
                            .padding(.leading, 8)
                            .padding(.vertical, 8)
                            
                            Spacer()
                            
                            Text("$4.000")
                        }
                        .padding(.leading)
                    }
                }
                .navigationTitle("Pick your ride")
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    RidePickerView()
}
