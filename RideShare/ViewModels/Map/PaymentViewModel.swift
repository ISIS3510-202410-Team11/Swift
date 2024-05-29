//
//  PaymentViewModel.swift
//  RideShare
//
//  Created by Cristian Caro on 4/05/24.
//

import Foundation
import Firebase
import Combine
import FirebaseFirestore

class PaymentViewModel: ObservableObject{
    //vars
    @Published var paymentMethods: [Payment] = []
    @Published var paymentMethods2: [Payment] = []
    
    @Published var rideId: String?
    @Published var showAlert = false
    @Published var loadingBool = true
    private var db = Firestore.firestore()
    private var isCheckingDatabase = false
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
                //print("Estado de lista actual es: \(self.paymentMethods)")
                print("DEBUG: Payment methods updated")
            }
            
        } catch {
            print("Error fetching payment data: \(error)")
        }
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
                        //print("DEBUGGGGG: \(self.paymentMethods2)")
                    } else{
                        self.paymentMethods2 = []
                    }
                }
            }
    }
    // NEW METHODS FOR ASYNC CHECK
    func updateRideStatus(completion: @escaping (Error?) -> Void) {
        guard let user = SessionManager.shared.currentUserProfile?.uid else {
            print("User not logged in")
            return
        }
        
        let document = Firestore.firestore().collection("active_trips").document(self.rideId!)
        print("DEBUG: DOCUMENT \(document)")
        // Obtener la lista actual de pasajeros
        document.getDocument { (snapshot, error) in
            if let error = error {
                completion(error)
                return
            }
            
            guard let snapshot = snapshot, let data = snapshot.data() else {
                completion(NSError(domain: "YourAppDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Snapshot data is nil"]))
                return
            }
            
            // Verificar el tamaño de la lista de pasajeros
            if let passengers = data["passengers"] as? [[String: Any]], passengers.count < 4 {
                // Construir el nuevo pasajero
                
                let newPassenger: [String: Any] = [
                    "id": user,
                    "name": SessionManager.shared.currentUserProfile?.name ?? "crisis",
                    "email": SessionManager.shared.currentUserProfile?.email ?? "c.caro@uniandes.edu.co"
                ]
                
                // Actualizar la lista de pasajeros solo si tiene un tamaño menor a 4
                document.updateData(["passengers": FieldValue.arrayUnion([newPassenger])]) { error in
                    completion(error)
                }
            } else {
                // Manejar el caso cuando la lista de pasajeros ya tiene 4 o más elementos
                completion(NSError(domain: "YourAppDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Maximum number of passengers reached"]))
            }
        }
    }
    

}
/*
 Use dispatch.main to update UI
 Publishing changes from background threads is not allowed;
 make sure to publish values from the main thread (via operators like receive(on:)) on model updates.
 */
