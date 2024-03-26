//
//  ProfileViewModel.swift
//  RideShare
//
//  Created by Juan Sebastian Pedraza Perez on 21/03/24.
//

import Foundation
import UIKit

class FormViewModel: NSObject, ObservableObject {
    @Published var userModel = UserModel(name: "", rating: 0.0,  cedula: 0, paymentMethod: "", profileImage: nil)
    
    @Published var userProfile: UserProfile?
    @Published var vehicles: [Vehicle] = []
    
    @Published var profileImage: UIImage?
    
    let paymentMethods = ["Nequi", "Efectivo", "Tarjeta"]
    func selectPaymentMethod(_ index: Int) {
            userModel.paymentMethod = paymentMethods[index]
        }

    private let imagePicker = UIImagePickerController()

    override init() {
        super.init()
        imagePicker.delegate = self
    }

    func selectImage(sourceType: UIImagePickerController.SourceType) {
        imagePicker.sourceType = sourceType
        if sourceType == .camera {
            imagePicker.cameraCaptureMode = .photo
        }

        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            rootViewController.present(imagePicker, animated: true, completion: nil)
        }
    }

    func saveFormData() {
        if let selectedImage = profileImage {
            userModel.profileImage = selectedImage.jpegData(compressionQuality: 0.5)
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

}

extension FormViewModel: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        profileImage = selectedImage
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
