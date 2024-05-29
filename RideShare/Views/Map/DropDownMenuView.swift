//
//  DropDownMenuView.swift
//  RideShare
//
//  Created by Cristian Caro on 5/05/24.
//

import SwiftUI

struct DropDownMenuView: View {
    let title: String
    let prompt: String
    let options: [String]
    
    @State private var isExpanded = false
    @State private var showAltert = false
    @ObservedObject var viewModel: PaymentViewModel = PaymentViewModel()
    @ObservedObject var networkManager = NetworkManager()
    @Binding var selection: String?
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .font(.footnote)
                .foregroundStyle(.gray)
                .opacity(0.8)
            //dropdown
            VStack{
                HStack{
                    Text(selection ?? prompt )
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .rotationEffect(.degrees(isExpanded ? -180 : 0))
                }
                .frame(height: 40)
                .padding(.horizontal)
                .onTapGesture {
                    withAnimation(.snappy){
                        isExpanded.toggle()
                    }
                }
                if isExpanded{
                    VStack{
                        ForEach(options, id: \.self){option in
                            HStack{
                                Text(option)
                                    .foregroundStyle(selection == option ? Color.primary : .gray)
                                Spacer()
                                if selection == option{
                                    Image(systemName: "checkmark")
                                        .font(.subheadline)
                                }
                            }
                            .frame(height: 40)
                            .padding(.horizontal)
                            .onTapGesture {
                                withAnimation(.snappy){
                                    //set user selection and collapse
                                    selection = option
                                    isExpanded.toggle()
                                }
                            }
                        }
                    }
                    .transition(.move(edge: .bottom))
                }
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 4)
            .frame(width: 360)
            Button{
                if networkManager.isConnected{
                    //print("DEBUG: There is connection on dropdown")
                    //User has connection: show creation alert
                    // Create payment
                    print("Create payment")
                    print("Selected method is: \(selection ?? "None")")
                    Task{
                        
                        try await viewModel.createPayment(name: selection ?? "Error", logo:"leaf.fill")
                        
                        
                    }
                    
                    //Close sheet
                    isPresented = false
                } else{
                    //print("DEBUG: There is NO connection on dropdown")
                    //No connection: show internet alert
                    showAltert = true
                }
            } label: {
                Text("Add Payment")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    .background(.green)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
            .alert(isPresented: $showAltert) {
                Alert(
                    title: Text("There is not connection to internet"),
                    message: Text("Please check your internet connection and try again."),
                    dismissButton: .default(Text("Accept"))
                )
            }
        }
    }
}

//#Preview {
//    DropDownMenuView(title: "Make", prompt: "Select", options: ["PayPal","DaviPlata","Especie"], selection: .constant("PayPal"), isPresented: .constant(false))
//}
