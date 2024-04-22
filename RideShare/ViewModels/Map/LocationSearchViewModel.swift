//
//  LocationSearchViewModel.swift
//  RideShare
//
//  Created by Cristian Caro on 22/03/24.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject{
    //MARKS
    @Published var results = [MKLocalSearchCompletion]()
    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment: String = ""{
        didSet{
            searchCompleter.queryFragment = queryFragment
        }
    }

    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate{
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
