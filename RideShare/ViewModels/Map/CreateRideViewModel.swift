//
//  CreateRideViewModel.swift
//  RideShare
//
//  Created by Pablo Junco on 28/05/24.
//

import Foundation
class CreateRideViewModel: ObservableObject{

    @Published var selectedLocation: String?
    @Published var selectedInstructions:[String] = []
    
    func updatedLocation(_ location:String){
        
        selectedLocation = location
        
        print("selected from create ride is: \(selectedLocation ?? "null") ")
        
        
        
    }
    
    func updatedInstructions(_ instructions: [String]){
        
        selectedInstructions = instructions
        print("selected instructions: \(selectedInstructions)")
    }
    
    
    
    
    
    
    
}

