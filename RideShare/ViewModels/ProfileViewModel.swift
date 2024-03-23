//
//  ProfileViewModel.swift
//  RideShare
//
//  Created by Juan Sebastian Pedraza Perez on 21/03/24.
//

import Foundation
import UIKit

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let firestoreManager = FirestoreManager.shared

    func fetchUser(byUID uid: String) {
        isLoading = true
        firestoreManager.fetchUser(withUID: uid) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let fetchedUser):
                    self?.user = fetchedUser
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}



