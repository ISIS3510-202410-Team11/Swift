//
//  PQRViewModel.swift
//  RideShare
//
//  Created by Cristian Caro on 21/05/24.
//

import Foundation
import Combine

class PQRViewModel: ObservableObject {
    @Published var selectedType: PQRType = .petition
    @Published var comment: String = ""
    
    enum PQRType: String, CaseIterable, Identifiable {
        case petition = "Petición"
        case complaint = "Queja"
        case claim = "Reclamo"
        
        var id: Self { self }
    }
    
    func submitPQR() {
        print("Tipo: \(selectedType.rawValue), Comentario: \(comment)")
    }
}
