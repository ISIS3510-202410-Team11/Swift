//
//  ProfileViewModel.swift
//  RideShare
//
//  Created by Juan Sebastian Pedraza Perez on 21/03/24.
//

import Foundation
import UIKit
import SwiftUI
import Network


class ProfileViewModel: NSObject, ObservableObject {
    @Published var userModel = UserProfile(uid: "", name: "",email:"", driver: false, newsletter: false, rating: "", payment: nil, profileImage: nil)
    @Published var userProfile: UserProfile?
    @Published var vehicles: [Vehicle] = []
    @Published var isUploadingImage = false
    @Published var profileImage: UIImage?
    @Published var selectedVehicleIndex: Int? = nil
    @Published var isDataLoaded = false
    
    override init() {
        super.init()
        loadUserProfileFromCache()
        loadVehiclesFromCache()
        printUserDefaultsContents()
        
    }
    
        init(mock: Bool = false) {
            super.init()
            if mock {
                self.userProfile = UserProfile(uid: "123", name: "Gandalf",email:"gandalf@thegray.com", driver: true, newsletter: false, rating: "5.0", payment: "Efe", profileImage: nil)
                self.vehicles = [Vehicle(id:"", type: "Car", plate: "XYZ123", reference: "Tesla Model S", color: "Red"), Vehicle(id:"", type: "Motobike", plate: "AAA123", reference: "Husq Varna", color: "Black")]
                self.profileImage = UIImage(systemName: "person.fill")
                saveUserProfileToCache()
                saveVehiclesToCache()
                printUserDefaultsContents()
            }
            else {
                
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
                        self.loadUserProfileFromCache()
                        self.loadVehiclesFromCache()
                        return
                    }

                    if let userProfile = userProfile {
                        self.userProfile = userProfile
                        self.saveUserProfileToCache()
                    }

                    if let vehicles = vehicles {
                        self.vehicles = vehicles
                        self.saveVehiclesToCache()
                    } else {
                        self.vehicles = []
                    }

                    self.isDataLoaded = true
                    self.printUserDefaultsContents()
                }
            }
        }
    
    func checkConnectivityAndFetchData() {
            let monitor = NWPathMonitor()
            monitor.pathUpdateHandler = { [weak self] path in
                if path.status == .satisfied {
                    self?.fetchUserData()
                } else {
                    self?.loadUserProfileFromCache()
                    self?.loadVehiclesFromCache()
                }
                monitor.cancel()
            }
            let queue = DispatchQueue(label: "Monitor")
            monitor.start(queue: queue)
        }

    
    
    
    func saveUserProfileToCache() {
            if let userProfile = userProfile {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(userProfile) {
                    UserDefaults.standard.set(encoded, forKey: "UserProfile")
                }
            }
        }

    func loadUserProfileFromCache() {
            if let savedUserData = UserDefaults.standard.object(forKey: "UserProfile") as? Data {
                let decoder = JSONDecoder()
                if let loadedUser = try? decoder.decode(UserProfile.self, from: savedUserData) {
                    userProfile = loadedUser
                }
            }
        }
    func printUserDefaultsContents() {
            print("Contents of UserDefaults for 'UserProfile':")
            if let userData = UserDefaults.standard.object(forKey: "UserProfile") as? Data {
                if let userDataAsString = String(data: userData, encoding: .utf8) {
                    print(userDataAsString)
                } else {
                    print("Could not decode user data to string.")
                }
            } else {
                print("No user data found in UserDefaults for UserProfile.")
            }
            
            print("Contents of UserDefaults for 'UserVehicles':")
            if let vehiclesData = UserDefaults.standard.object(forKey: "UserVehicles") as? Data {
                if let vehiclesDataAsString = String(data: vehiclesData, encoding: .utf8) {
                    print(vehiclesDataAsString)
                } else {
                    print("Could not decode vehicles data to string.")
                }
            } else {
                print("No vehicles data found in UserDefaults.")
            }
        }
    
    
    func saveVehiclesToCache() {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(vehicles) {
                UserDefaults.standard.set(encoded, forKey: "UserVehicles")
            }
        }

        func loadVehiclesFromCache() {
            if let savedVehiclesData = UserDefaults.standard.object(forKey: "UserVehicles") as? Data {
                let decoder = JSONDecoder()
                if let loadedVehicles = try? decoder.decode([Vehicle].self, from: savedVehiclesData) {
                    vehicles = loadedVehicles
                }
                printUserDefaultsContents()
            
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

