//
//  PaymentView.swift
//  RideShare
//
//  Created by Cristian Caro on 24/04/24.
//

import SwiftUI

struct PaymentView: View {
    @State private var payments = Payment.preview()
    @State private var selectedPayment: Payment?
    @State private var showAlert = false
    @ObservedObject var networkManager = NetworkManager()
    
    var body: some View {
        VStack(spacing: 8){
            //TITLE
            Text("Choose your payment method")
                .fontWeight(.bold)
            //lIST
            List{
                ForEach(payments, id: \.name){ payment in
                    Button(action: {
                        selectedPayment = payment // Set selected payment
                    }) {
                        HStack(spacing: 8){
                            Image(systemName: payment.image)
                                .padding(2)
                                .foregroundColor(.black)
                            Text(payment.name)
                                .foregroundColor(.black)
                        }
                    }
                    .listRowBackground(selectedPayment == payment ? Color.green : Color.clear) // Highlight selected row
                }
            }
            .background(Color.white)
            //BUTTON
            GreenButton(tittle: "Pay Now"){
                guard let selectedPayment = selectedPayment else { return }
                print("DEBUG: Selected Payment method is \(selectedPayment.name)")
                ClickCounter.shared.incrementCount()
                ClickCounter.shared.incrementRidesPayed()
                withAnimation(.spring()) {
                        if !networkManager.isConnected {
                            //print("DEBUG: NO INTERNET")
                            showAlert = true
                        } else {
                            //Need to be defined
                            //Change mapState from here
                        }
                    }
            }
            .padding(.bottom,90)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("No Internet Connection"),
                    message: Text("Please check your internet connection and try again."),
                    dismissButton: .default(Text("Accept"))
                )
            }
        }
        .background(Color.white)
        
    }
}


#Preview {
    PaymentView()
}
