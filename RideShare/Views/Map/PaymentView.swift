//
//  PaymentView.swift
//  RideShare
//
//  Created by Cristian Caro on 24/04/24.
//

import SwiftUI

struct PaymentView: View {
    @ObservedObject var networkManager = NetworkManager()
    @ObservedObject var viewModel: PaymentViewModel = PaymentViewModel()
    
    @State private var selectedPayment: Payment?
    @State private var showAlert = false
    @State private var selectedMake: String?
    @State private var isShowingNewView = false
    
    private let paymentOptions = [
        "PayPal",
        "DaviPlata",
        "PSE",
        "Bold"
    ]
    
    var body: some View {
        VStack(spacing: 8){
            //TITLE
            HStack {
                Text("Choose your payment method")
                    .fontWeight(.bold)
                Button{
                    Task{
                        //neg async
                        viewModel.fetchPaymentsData()
                    }
                    //viewModel.fetchPaymentsData()
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
            //LIST
            List{
                ForEach(Array(viewModel.paymentMethods2.enumerated()), id: \.element){ index, payment in
                    Button(action: {
                        selectedPayment = payment // Set selected payment
                    }) {
                        HStack(spacing: 8){
                            Image(systemName: payment.logo)
                                .padding(2)
                                .foregroundColor(.black)
                            Text(payment.name)
                                .foregroundColor(.black)
                        }
                    }
                    // Highlight selected row
                    .listRowBackground(selectedPayment == payment ? Color.green : Color.clear)
                    
                }
                Button{
                    isShowingNewView.toggle()
                }label: {
                    HStack(spacing: 8){
                        Image(systemName: "plus.app")
                            .foregroundColor(.green)
                            .padding(2)
                        Text("Add new payment method")
                            .foregroundColor(.black)
                    }
                }
                .sheet(isPresented: $isShowingNewView){
                    DropDownMenuView(title: "Select new payment method", prompt: "Select", options: paymentOptions, selection: $selectedMake, isPresented: $isShowingNewView)
                        .presentationDetents([.height(350), .medium])
                        .presentationDragIndicator(.visible)
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
        //ends vstack
        .background(Color.white)
    }
}


#Preview {
    PaymentView()
}
