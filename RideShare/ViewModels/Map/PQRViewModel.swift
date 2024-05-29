//
//  PQRViewModel.swift
//  RideShare
//
//  Created by Cristian Caro on 21/05/24.
//

import Foundation
import Combine
import FirebaseFirestore

class PQRViewModel: ObservableObject {
    @Published var selectedType: PQRType = .petition
    @Published var comment: String = ""
    @Published var showAlert = false
    private var db = Firestore.firestore()

    
    enum PQRType: String, CaseIterable, Identifiable {
        case petition = "Petition"
        case complaint = "Complaint"
        case claim = "Claim"
        
        var id: Self { self }
    }
    
    func submitPQR(){
        guard let uid = SessionManager.shared.currentUserProfile?.uid else {
            print("User not logged in")
            return
        }
        let newPQR = PQR(user: uid, type: self.selectedType.rawValue, comment: self.comment)
        Task{
            do{
                try await createPQR(pqr: newPQR)
            } catch{
                print("DEBUG: ERROR CREATING PQR OBJECT")
            }
            
        }
    }
    func createPQR(pqr: PQR) async throws {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(pqr)
            guard let pqrDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                throw NSError(domain: "YourAppDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert PQR to JSON dictionary"])
            }
            
            let pqrDocRef = db.collection("PQRs").document()
            try await pqrDocRef.setData(pqrDict)
            self.showAlert = true
        } catch {
            throw error
        }
        
    }

}
