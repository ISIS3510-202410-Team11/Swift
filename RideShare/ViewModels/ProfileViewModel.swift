//
//  ProfileViewModel.swift
//  RideShare
//
//  Created by Juan Sebastian Pedraza Perez on 21/03/24.
//

import Foundation
import UIKit

class ProfileViewModel: NSObject, ObservableObject {
    @Published var userModel = UserProfile(uid: "", name: "",email:"", driver: false, newsletter: false, rating: "", payment: nil, profileImage: nil)
    
    @Published var userProfile: UserProfile?
    @Published var vehicles: [Vehicle] = []
    @Published var isUploadingImage = false
    
    @Published var profileImage: UIImage?
    
    @Published var selectedVehicleIndex: Int? = nil
    
    // Initialize with mock data for previews or testing
        init(mock: Bool = false) {
            if mock {

                self.userProfile = UserProfile(uid: "123", name: "Gandalf",email:"gandalf@thegray.com", driver: true, newsletter: false, rating: "5.0", payment: "Efe", profileImage: nil)
                self.vehicles = [Vehicle(id:"", type: "Car", plate: "XYZ123", reference: "Tesla Model S", color: "Red"), Vehicle(id:"", type: "Motobike", plate: "AAA123", reference: "Husq Varna", color: "Black")]
                self.profileImage = UIImage(systemName: "person.fill")
            }
        }
    
    func fetchUserData() {
            guard let uid = SessionManager.shared.currentUserProfile?.uid else {
                print("User not logged in")
                return
            }
            
            FirestoreManager.shared.fetchUserData(uid: uid) { [weak self] userProfile, vehicles, error in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    
                    if let error = error {
                        print("Error fetching user data: \(error)")
                        return
                    }
                    
                    self.userProfile = userProfile
                    
                    // Update to handle an array of vehicles
                    if let vehicles = vehicles {
                        self.vehicles = vehicles
                    } else {
                        self.vehicles = [] 
                    }
                }
            }
        }
    
    func updateVehicleImage(for index: Int, with newImage: UIImage) {
        guard let userUID = SessionManager.shared.currentUserProfile?.uid, vehicles.indices.contains(index) else {
            print("Invalid user UID or vehicle index")
            return
        }

        let vehicle = vehicles[index]
        if vehicle.image != nil {
                    print("Ya se ha subido una imagen para este vehículo y no se puede cambiar.")
                    return
                }
        isUploadingImage = true
        FireStorageManager.shared.uploadVehicleImage(newImage, forVehicleWithID: vehicle.id, userUID: userUID) { [weak self] result in
            DispatchQueue.main.async {
                self?.isUploadingImage = false
                switch result {
                case .success(let url):
                    
                    FirestoreManager.shared.updateVehicleImage(with: vehicle.id, imageUrl: url.absoluteString, forUserUID: userUID)

                    
                    self?.vehicles[index].image = url.absoluteString
                    
                    
                    
                case .failure(let error):
                    print("Error uploading image: \(error.localizedDescription)")
                    
                }
            }
        }
    }
    
    func removeVehicle(at index: Int) {
        guard vehicles.indices.contains(index) else { return }
        let vehicleToRemove = vehicles[index]

        guard let userUID = SessionManager.shared.currentUserProfile?.uid else {
            return
        }

        FirestoreManager.shared.removeVehicle(forUserUID: userUID, vehicleID: vehicleToRemove.id) { [weak self] error in
            if let error = error {
                print("Error removing vehicle: \(error.localizedDescription)")
            } else {
                
                DispatchQueue.main.async {
                    self?.vehicles.remove(at: index)
                    
                    // Simple strategy: hard reseting
                    self?.selectedVehicleIndex = nil
                }
            }
        }
        
        
    }

}

