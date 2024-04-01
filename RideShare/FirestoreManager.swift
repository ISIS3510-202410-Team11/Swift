//
//  FirestoreManager.swift
//  RideShare
//
//  Created by Pablo Junco on 22/03/24.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

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
                vehicles[index]["imageUrl"] = imageUrl
                
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

    
}
  

