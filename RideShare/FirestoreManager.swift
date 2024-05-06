//
//  FirestoreManager.swift
//  RideShare
//
//  Created by Pablo Junco on 22/03/24.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth //new

class FirestoreManager {
    static let shared = FirestoreManager()
    let db = Firestore.firestore()
    
    private init() {} // Private initialization to ensure singleton instance

    func addUser(user: UserProfile, completion: @escaping (Error?) -> Void) {
        do {
            
            try db.collection("users").document(user.uid).setData(from: user) { error in
                completion(error)
            }
        } catch let error {
            
            completion(error)
        }
    }
    
    
    
    
    func addVehicle(forUserUID userUID: String, vehicle: Vehicle, completion: @escaping (Error?) -> Void) {
        do {
            // Convert the vehicle object into JSON data
            let data = try JSONEncoder().encode(vehicle)
            // Convert the JSON data into a dictionary
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert JSON data to dictionary"]))
                return
            }

            // Now use the dictionary to update the Firestore document
            let userDocRef = db.collection("users").document(userUID)
            userDocRef.updateData([
                "vehicles": FieldValue.arrayUnion([dictionary])
            ]) { error in
                completion(error)
            }

        } catch let error {
            completion(error)
        }
    }
    
    
    
    func fetchUserData(uid: String, completion: @escaping (UserProfile?, [Vehicle]?, Error?) -> Void) {
        let userDocRef = db.collection("users").document(uid)
        
        userDocRef.getDocument { document, error in
            if let error = error {
                completion(nil, nil, error)
                return
            }
            
            guard let document = document, document.exists, let data = document.data() else {
                completion(nil, nil, nil) // No document found, but not necessarily an error
                return
            }
            
            guard let userProfile = try? document.data(as: UserProfile.self) else {
                completion(nil, nil, nil) // Failed to decode UserProfile
                return
            }
            
            if let vehicleDataArray = data["vehicles"] as? [[String: Any]] {
                let vehicles: [Vehicle] = vehicleDataArray.compactMap { vehicleDict in
                    
                    return try? Firestore.Decoder().decode(Vehicle.self, from: vehicleDict)
                }
                
                completion(userProfile, vehicles, nil)
            } else {
                
                completion(userProfile, nil, nil)
            }
        }
    }
    
    func removeVehicle(forUserUID userUID: String, vehicleID: String, completion: @escaping (Error?) -> Void) {
        let userDocRef = db.collection("users").document(userUID)

        userDocRef.getDocument { (document, error) in
            if let document = document, let data = document.data(), var vehiclesArray = data["vehicles"] as? [[String: Any]] {
                // Find the index of the vehicle to remove
                if let indexToRemove = vehiclesArray.firstIndex(where: { $0["id"] as? String == vehicleID }) {
                    // Remove the vehicle from the array
                    vehiclesArray.remove(at: indexToRemove)

                    
                    userDocRef.updateData(["vehicles": vehiclesArray]) { error in
                        completion(error)
                    }
                } else {
                    completion(nil) // Vehicle not found
                }
            } else {
                completion(error ?? NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch user document"]))
            }
        }
    }
    

    func updateVehicleImage(with vehicleID: String, imageUrl: String, forUserUID userUID: String) {
        
        let userDocRef = db.collection("users").document(userUID)

        userDocRef.getDocument { (document, error) in
            guard let document = document, var data = document.data(), var vehicles = data["vehicles"] as? [[String: Any]] else {
                print("Document does not exist or vehicles array cannot be fetched")
                return
            }
            
            // Find the index of the vehicle to update
            if let index = vehicles.firstIndex(where: { $0["id"] as? String == vehicleID }) {
                // Update the imageUrl for the found vehicle
                vehicles[index]["image"] = imageUrl
                
                // Update the entire vehicles array in Firestore
                userDocRef.updateData(["vehicles": vehicles]) { error in
                    if let error = error {
                        print("Error updating document: \(error.localizedDescription)")
                    } else {
                        print("Document successfully updated")
                    }
                }
            } else {
                print("Vehicle not found")
            }
        }
    }

    
    static func updateDriverStatus(uid: String, isDriver: Bool, completion: @escaping (Error?) -> Void) {
            let document = Firestore.firestore().collection("users").document(uid)
            document.updateData(["driver": isDriver]) { error in
                completion(error)
            }
        }

    func fetchActiveTripsData() async throws -> [ActiveTrips] {
        // Reference to active trips collection
        let activeTripsDocRef = db.collection("active_trips")
        
        do {
            // Fetch documents asynchronously
            let querySnapshot = try await activeTripsDocRef.getDocuments()
            
            // Check if documents were found
            guard !querySnapshot.documents.isEmpty else {
                throw NSError(domain: "YourAppDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "No documents were found"])
            }
            
            // Map each document to ActiveTrips
            let activeTrips = try querySnapshot.documents.compactMap { document -> ActiveTrips in
                guard let activeTrip = try document.data(as: ActiveTrips?.self) else {
                    throw NSError(domain: "YourAppDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode ActiveTrips"])
                }
                return activeTrip
            }
            
            return activeTrips
        } catch {
            // Handle errors
            throw error
        }
    }
    func fetchPaymentData() async throws -> [Payment] {
        // Reference to active trips collection
        let paymentDocRef = db.collection("payment")
        
        do {
            // Fetch documents asynchronously
            let querySnapshot = try await paymentDocRef.getDocuments()
            
            // Check if documents were found
            guard !querySnapshot.documents.isEmpty else {
                throw NSError(domain: "YourAppDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "No documents were found"])
            }
            
            // Map each document to ActiveTrips
            let payments = try querySnapshot.documents.compactMap { document -> Payment in
                guard let eachPayment = try document.data(as: Payment?.self) else {
                    throw NSError(domain: "YourAppDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode ActiveTrips"])
                }
                return eachPayment
            }
            
            return payments
        } catch {
            // Handle errors
            throw error
        }
    }
    func createPayment(payment: Payment) async throws {
        // Create JSON Encoder
        let encoder = JSONEncoder()
        
        do {
            // Convert Payment object to JSON Data
            let jsonData = try encoder.encode(payment)
            
            // Convert JSON Data to NSDictionary
            guard let paymentDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                throw NSError(domain: "YourAppDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert Payment to JSON dictionary"])
            }
            
            // Reference to the "payments" collection
            let paymentDocRef = db.collection("payment").document(payment.id)
            
            // Save the payment dictionary to Firestore
            try await paymentDocRef.setData(paymentDict)
        } catch {
            // Handle errors
            throw error
        }
    }
    func fetchPayments2(completion: @escaping ([Payment]?, Error?) -> Void) {
            //Reference to active trips collection
            let payDocRef = db.collection("payment")
            
            //Access document and do query: query for activeTripsDocRef
            payDocRef.getDocuments { querySnapshot, error in
                if let error = error {
                    // Error obtaining the documents: connection or something
                    print("DEBUG: ERROR 1")
                    completion(nil, error)
                    return
                }
                guard (querySnapshot?.documents) != nil else {
                    // No documents found:
                    print("DEBUG: ERROR 2")
                    completion(nil, NSError(domain: "YourAppDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "No documents were found"]))
                    return
                }
                //Map each document
                let payments = querySnapshot?.documents.compactMap { document -> Payment? in
                            guard let pay = try? document.data(as: Payment.self) else {
                                // Active trips could not be decoded
                                return nil
                            }
                            return pay
                        }
                // Return active trips list
                completion(payments, nil)
            }
        }



}
