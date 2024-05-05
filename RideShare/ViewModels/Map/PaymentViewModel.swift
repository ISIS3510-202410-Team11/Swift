//
//  PaymentViewModel.swift
//  RideShare
//
//  Created by Cristian Caro on 4/05/24.
//

import Foundation
import Firebase
import Combine

class PaymentViewModel: ObservableObject{
    //vars
    @Published var paymentMethods: [Payment] = []
    //init
    init() {
        load()
    }
    func load(){
        Task(priority: .medium){
            print("DEBUG: PAYMENTSSSSS")
            try await getPayments()
        }
    }
    //functions
    func createPayment() async throws{
        print("DEBUG: Create payment method")
    }
    func getPayments() async throws{
        do {
            let paymentsData = try await FirestoreManager.shared.fetchPaymentData()
            DispatchQueue.main.async { // Communicate with main thread so he publishes
                self.paymentMethods = paymentsData
            }
            
        } catch {
            print("Error fetching payment data: \(error)")
        }
    }
    func deletePayment() async throws{
        print("DEBUG: Delete payment method")
    }
}
/*
 Use dispatch.main to update UI
 Publishing changes from background threads is not allowed;
 make sure to publish values from the main thread (via operators like receive(on:)) on model updates.
 */
