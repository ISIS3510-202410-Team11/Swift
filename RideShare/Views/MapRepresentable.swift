//
//  MapRepresentable.swift
//  RideShare
//
//  Created by Cristian Caro on 22/03/24.
//

import Foundation
import SwiftUI
import MapKit

struct MapRepresentable: UIViewRepresentable{

    let mapView = MKMapView()
    let locationservice = LocationService()

    //Createview
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator //handler
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }
    //Updateview
    func updateUIView(_ uiView: UIViewType, context: Context) {

    }

    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension MapRepresentable{
    // Coordinator is the middle man between UI view and UIkit functions
    class MapCoordinator: NSObject, MKMapViewDelegate{ //Delegate has functions like generate locations, lines, etc
        let parent: MapRepresentable //Parent is the counication between class and MKMapCoordinator
        init(parent: MapRepresentable) {
            self.parent = parent
            super.init()
        }
        //Access user location and create region to work on
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: userLocation.coordinate.latitude,
                    longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.05, //more zoom the smaller it is
                    longitudeDelta: 0.05) //more zoom the smaller it is
            )
            parent.mapView.setRegion(region, animated: true)
        }
    }
}
