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
    @Published var paymentMethods2: [Payment] = []
    //init
    init() {
        load()
        fetchPaymentsData()
    }
    func load(){
        Task(priority: .userInitiated){
            do{
                print("DEBUG: First Load of payments")
                try await getPayments()
            } catch{
                print("DEBUG: Error loading payments: \(error)")
            }
        }
    }
    //functions
    func createPayment(name: String, logo: String) async throws{
        do {
            //Random ID for payment: Hash method could be used
            let id = UUID().uuidString
            let newPayment = Payment(id: id, logo: logo, name: name)
            try await FirestoreManager.shared.createPayment(payment: newPayment)
            //update view
            //print("DEBUG: Sleeping")
            //try await Task.sleep(nanoseconds: 5 * 1_000_000_000) // Wait 5 second
            //print("DEBUG: awake")
            //print("DEBUG: Update UI")
            //try await getPayments()
            print("To update List is: \(self.paymentMethods)")
            //self.objectWillChange.send()
        } catch {
            print("Error fetching payment data: \(error)")
        }
        
    }
    @MainActor //do it on the main thread, might solve concurrence
    func getPayments() async throws{
        do {
            print("DEBUG: Payment methods will be updated")
            let paymentsData = try await FirestoreManager.shared.fetchPaymentData()
            DispatchQueue.main.async { // Communicate with main thread so he publishes
                self.paymentMethods = paymentsData
                print("Estado de lista actual es: \(self.paymentMethods)")
                print("DEBUG: Payment methods updated")
            }
            
        } catch {
            print("Error fetching payment data: \(error)")
        }
    }
    func deletePayment() async throws{
        print("DEBUG: Delete payment method")
    }
    func fetchPaymentsData(){
            FirestoreManager.shared.fetchPayments2(){ [weak self] payments, error in
                DispatchQueue.main.async {
                    guard let self = self else { return }

                    if let error = error {
                        print("Error fetching payments data: \(error)")
                        return
                    }
                    if let payments = payments {
                        self.paymentMethods2 = payments
                        print("DEBUGGGGG: \(self.paymentMethods2)")
                    } else{
                        self.paymentMethods2 = []
                    }
                }
            }
        }
}
/*
 Use dispatch.main to update UI
 Publishing changes from background threads is not allowed;
 make sure to publish values from the main thread (via operators like receive(on:)) on model updates.
 */
