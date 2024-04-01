//
//  FireStorageManager.swift
//  RideShare
//
//  Created by Pablo Junco on 31/03/24.
//

import FirebaseStorage
import UIKit

class FireStorageManager {
    static let shared = FireStorageManager() // Singleton instance
    private let storageRef = Storage.storage().reference()
    
    private init() {}
    
    func uploadVehicleImage(_ image: UIImage, forVehicleWithID vehicleID: String, userUID: String, completion: @escaping (Result<URL, Error>) -> Void) {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                completion(.failure(NSError(domain: "FireStorageManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "JPEG conversion failed"])))
                return
            }
            
            let vehicleImageRef = storageRef.child("vehicle_images/\(vehicleID).jpg")
            
            vehicleImageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                vehicleImageRef.downloadURL { url, error in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url))
                    }
                }
            }
    }

}
