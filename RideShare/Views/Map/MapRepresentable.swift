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
    //this class does not publish, just observes
    let mapView = MKMapView()
    let locationservice = LocationService() //it needs to be initiallized, it has the permissions
    
    @Binding var mapState: MapViewState
    @EnvironmentObject var locationViewModel: LocationSearchViewModel //Another instance that does not know about selectedLocation

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
        print("DEBUG: Map state is \(mapState)")
        switch mapState {
        case .noInput:
            context.coordinator.clearMapView()
            break
        case .locationSelected:
            //HERE WE MUST CHANGE TO SOLVE LOCATION NOT FOUND BUG
            if !locationViewModel.locationError{
                //IF EVERYTHING IS OK
                if let coordinate = locationViewModel.selectedLocation?.coordinate{
                    print("DEBUG: Adding stuff to map")
                    context.coordinator.addSelectAnnotation(withCoordinate: coordinate)//call function to set annotation
                    context.coordinator.createPolyline(withDestinationCoordinate: coordinate)
                }
            } else{
                //DO NOTHING
                //WE SHOULD GO BACK TO LOCATION SEARCH VIEW
                //ERROR STILL OPEN, NEED TO CHECK LATER
                print("DEBUG: GOING HOME HARD")
                mapState = .searchingForLocation //THIS SHOULD BE DONE AFTER ALERT MESSAGE (HOW TO TALK TO VIEW WHEN WE DON'T PUBLISH)
            }
            break

        case .searchingForLocation:
            break
        case .polylineaddded:
            break
        case .rideOffers:
            break
        case .payment:
            break
        case .createRide:
                    break
        }
    }

    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension MapRepresentable{
    // Coordinator is the middle man between UI view and UIkit functions
    class MapCoordinator: NSObject, MKMapViewDelegate{ //Delegate has functions like generate locations, lines, etc
        
        let parent: MapRepresentable //Parent is the counication between class and MKMapCoordinator
        var userLocationCoordinate: CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?
        
        init(parent: MapRepresentable) {
            self.parent = parent
            super.init()
        }
        //Access user location and create region to work on
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate //give the class access to the userCoords
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: userLocation.coordinate.latitude,
                    longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.05, //more zoom the smaller it is
                    longitudeDelta: 0.05) //more zoom the smaller it is
            )
            //print("DEBUG: bug bug bug") CAREFUL WITH LOGIC, PAST WAS: "IF STATE NOT POLYLINE AND NO NOINPUT" BUT NEW STATES CHANGE ALL
            if self.parent.mapState == .locationSelected || self.parent.mapState == .searchingForLocation{
                print("DEBUG: user region will be defined")
                self.currentRegion=region
                parent.mapView.setRegion(region, animated: true)
            }
            //generates bug of always setting users location region
            //self.currentRegion=region //update users region
            //parent.mapView.setRegion(region, animated: true)//set map region on users location
        }
        //delegate method to draw
        /* IT NEEDS TO BE TESTED IF POLYLINE NEEDS TO BE RESET BEFORE DRAWING, EDITOR IS CRAZY
        04 of May: Works ok, not drawing problems, check connectivity and redraw cases without internet (block triggers) */
        func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .systemBlue
            polyline.lineWidth = 6
            return polyline
        }
        func addSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D){
            parent.mapView.removeAnnotations(parent.mapView.annotations)//delete to have just one annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate =  coordinate
            parent.mapView.addAnnotation(annotation)
            parent.mapView.selectAnnotation(annotation, animated: true)//animation to make annotation bigger
            
        }
        func createPolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D){
            guard let userLocationCoordinate = self.userLocationCoordinate else{return}
            parent.locationViewModel.getDestinationRoute(from: userLocationCoordinate, to: coordinate){route in
                self.parent.mapView.addOverlay(route.polyline)//get direction
                self.parent.mapState = .polylineaddded //intermediate swap
                //Based on ridepicker view size we define
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,
                                                               edgePadding: .init(top:64,left: 32,
                                                                                  bottom: 300,right: 32))
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)//rect is rectangle
            }
        }

        func clearMapView(){
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            if let currentRegion = currentRegion{
                parent.mapView.setRegion(currentRegion, animated: true)
            }
            
        }
    }
}
