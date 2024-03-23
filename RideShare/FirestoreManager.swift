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

    func addUser(user: User, completion: @escaping (Error?) -> Void) {
        do {
            // Note: The document path uses `user.uid` to ensure the document ID matches the user's UID
            try db.collection("users").document(user.uid).setData(from: user) { error in
                completion(error)
            }
        } catch let error {
            // Handle any errors from encoding the user object
            completion(error)
        }
    }
    
    func addVehicle(forUserUID userUID: String, vehicle: Vehicle, completion: @escaping (Error?) -> Void) {
        do {
            // Add the vehicle to a "vehicles" subcollection under the user's document
            try db.collection("users").document(userUID).collection("vehicles").addDocument(from: vehicle, completion: completion)
        } catch let error {
            completion(error)
        }
    }
    
    func fetchUser(withUID uid: String, completion: @escaping (Result<User, Error>) -> Void) {
            //Get a user with a certain UID.
            db.collection("users").document(uid).getDocument { (document, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let document = document, document.exists,
                      let user = try? document.data(as: User.self) else {
                    completion(.failure(FirestoreError.nonExistentDocument))
                    return
                }
                completion(.success(user))
            }
        }
}
  
enum FirestoreError: Error {
    case nonExistentDocument
}
