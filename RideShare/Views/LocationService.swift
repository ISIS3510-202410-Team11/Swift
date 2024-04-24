//
//  LocationService.swift
//  RideShare
//
//  Created by Cristian Caro on 22/03/24.
//

import CoreLocation

class LocationService: NSObject, ObservableObject{
    private let locationservice = CLLocationManager()
    //similar to env object
    //aaa static let shared = LocationService()
    //aaa @Published var userLocation: CLLocationCoordinate2D?

    override init(){
        super.init()
        locationservice.delegate = self
        locationservice.desiredAccuracy = kCLLocationAccuracyBest
        locationservice.requestWhenInUseAuthorization()//permisos y privacy
        locationservice.startUpdatingLocation()//update user location
    }
}

extension LocationService: CLLocationManagerDelegate{
    //Function that updates users locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //aaa guard let location = locations.first else{ return }
        //aaa self.userLocation = location.coordinate
        guard !locations.isEmpty else {return}
        //avoid getting the location everytime as it does it more than once
        //the user location is in the mapRepresentable but sharing it is difficult
        locationservice.stopUpdatingLocation()
    }
}
