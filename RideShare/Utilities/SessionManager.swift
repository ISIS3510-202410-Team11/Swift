//
//  SessionManager.swift
//  RideShare
//
//  Created by Pablo Junco on 25/03/24.
//

import Firebase
import LocalAuthentication

import Firebase
import Combine

class SessionManager: ObservableObject {
    static let shared = SessionManager() // Singleton instance
    @Published var currentUserProfile: UserProfile? = nil

    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    private var db = Firestore.firestore()
    var isDriver: Bool {
                currentUserProfile?.driver ?? false
            }

    private init() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            guard let self = self else { return }
            if let user = user {
                self.fetchUserProfile(uid: user.uid)
            } else {
                self.currentUserProfile = nil
            }
        }
    }
    
    func updateRole(isDriver: Bool) {
            guard var profile = currentUserProfile else {
                print("No user profile available")
                return
            }
            profile.driver = isDriver
            currentUserProfile = profile
            objectWillChange.send() // Notifying observers about the change

            FirestoreManager.updateDriverStatus(uid: profile.uid, isDriver: profile.driver) { error in
                if let error = error {
                    print("Failed to update driver status in Firestore: \(error)")
                } else {
                    print("Driver status updated successfully")
                }
            }
        }

    func fetchUserProfile(uid: String) {
        let docRef = db.collection("users").document(uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                guard let userData = dataDescription else { return }
                self.currentUserProfile = UserProfile(
                    uid: uid,
                    name: userData["name"] as? String ?? "",
                    email: userData["email"] as? String ?? "",
                    driver: userData["driver"] as? Bool ?? false,
                    newsletter: userData["newsletter"] as? Bool ?? false
                )
            } else {
                print("Document does not exist")
                self.currentUserProfile = nil
            }
        }
    }
    
    func registerUser(email: String, password: String, name: String, isDriver: Bool, wantsNewsletter: Bool, completion: @escaping (Bool, Error?) -> Void) {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    completion(false, error)
                    return
                }
                guard let user = authResult?.user else {
                    completion(false, nil)
                    return
                }
                let newUserProfile = UserProfile(uid: user.uid, name: name, email: email, driver: isDriver, newsletter: wantsNewsletter)
                // Save the new user profile to Firestore
                FirestoreManager.shared.addUser(user: newUserProfile) { error in
                    if let error = error {
                        completion(false, error)
                    } else {
                        completion(true, nil)
                        // Optionally update the SessionManager's currentUserProfile here
                        DispatchQueue.main.async {
                            self.currentUserProfile = newUserProfile
                        }
                    }
                }
            }
        }
    
    deinit {
        if let authStateDidChangeListenerHandle = authStateDidChangeListenerHandle {
            Auth.auth().removeStateDidChangeListener(authStateDidChangeListenerHandle)
        }
    }
    
    func authenticateUserUsingFaceID(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var error: NSError?

        // Check if Face ID is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate with Face ID to access your account securely."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        completion(true, nil)
                    } else {
                        completion(false, authenticationError)
                    }
                }
            }
        } else {
            // Face ID not available
            DispatchQueue.main.async {
                completion(false, error)
            }
        }
    }

    // sign out the current user
    func signOut() {
        do {
            try Auth.auth().signOut()
            currentUserProfile = nil
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

}
