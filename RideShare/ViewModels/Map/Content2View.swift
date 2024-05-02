//
//  Content2View.swift
//  RideShare
//
//  Created by Cristian Caro on 1/05/24.
//

import SwiftUI

struct Content2View: View {
    @ObservedObject var networkManager = NetworkManager()
    var body: some View {
        ZStack{
            Color(.systemBlue).ignoresSafeArea()
            VStack{
                Image(systemName: networkManager.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.white)
                
                Text(networkManager.connectionDescription)
                    .font(.system(size: 18))
                    .foregroundStyle(.white)
                    .padding()
                if !networkManager.isConnected{
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        .scaleEffect(3)
                    
                    Button{
                        print("Handle action")
                    } label: {
                        Text("Retry")
                            .padding()
                            .font(.headline)
                            .foregroundColor(Color(.blue))
                    }
                    .frame(width: 140)
                    .background(Color(.white))
                    .clipShape(Capsule())
                    .padding()
                }
            }
        }
    }
}

#Preview {
    Content2View()
}
