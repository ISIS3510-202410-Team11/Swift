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
    @Published var selectedLocation: Location?
    @Published var pickUpTime: String?
    @Published var dropOffTime: String?
    
    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment: String = ""{
        didSet{
            searchCompleter.queryFragment = queryFragment
        }
    }
    //aaa var userLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    func selectLocation(_ location:MKLocalSearchCompletion){
        locationSearch(forLocalSearchCompletion: location){response, error in
            if let error = error{
                print("DEBUG: Location search failed with error \(error.localizedDescription)")
                return //because we wanna go out the function
            }
            guard let item = response?.mapItems.first //map item where we can get coords
            else {return}
            let coordinate = item.placemark.coordinate
            self.selectedLocation = Location(title: location.title, coordinate: coordinate) //save value
            print("DEBUG: Location coordinate \(coordinate)")
        }
    }
    func locationSearch(forLocalSearchCompletion localSearch:MKLocalSearchCompletion,
                        completion: @escaping MKLocalSearch.CompletionHandler){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)//configure
        let search = MKLocalSearch(request: searchRequest)//search
        search.start(completionHandler: completion)//handler because of API, rta comes as callback (takes time)
    }
    //came from map representable
    func getDestinationRoute(from userLocation: CLLocationCoordinate2D, to destination:CLLocationCoordinate2D,
                             completion: @escaping(MKRoute)-> Void){
        let userPlaceMark = MKPlacemark(coordinate: userLocation)
        let destinationPlaceMark = MKPlacemark(coordinate: destination)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlaceMark)
        request.destination = MKMapItem(placemark: destinationPlaceMark)
        let directions = MKDirections(request: request)
        //API creates the route with the info of request
        directions.calculate{response, error in
            if let error = error{
                print("DEBUG: Failed to get directions with error \(error)")
                return //go out the function
            }
            guard let route = response?.routes.first else {return}//the first one is usually the fastest
            self.configureTime(with: route.expectedTravelTime)
            completion(route)
        }
    }
    func configureTime(with expectedTravelTime: Double){
        let formater = DateFormatter()
        formater.dateFormat = "hh:mm a"
        pickUpTime = formater.string(from: Date())
        dropOffTime = formater.string(from: Date() + expectedTravelTime * 1.5)
    }
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate{
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
