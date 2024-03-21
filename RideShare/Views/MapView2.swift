//
//  MapView2.swift
//  RideShare
//
//  Created by Cristian Caro on 20/03/24.
//

import SwiftUI
import MapKit

struct MapView2: View {
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    @State private var searchText = ""
    @State private var results = [MKMapItem]()
    @State private var mapSelection: MKMapItem?
    @State private var showDetails = false
    
    var body: some View {
        Map(position: $cameraPosition, selection: $mapSelection){
            
            Annotation("my location", coordinate: .userLocation){
                ZStack{
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/.opacity(0.25))
                    Circle()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.white)
                    Circle()
                        .frame(width: 12, height: 12)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                }
            }
            ForEach(results, id: \.self){item in
                let placemark = item.placemark
                Marker(placemark.name ?? "", coordinate: placemark.coordinate)
            }
        }
        .overlay(alignment: .top){
            TextField("Search for a location", text: $searchText)
                .font(.subheadline)
                .padding(12)
                .background(.white)
                .padding()
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        }
        .onSubmit(of: /*@START_MENU_TOKEN@*/.text/*@END_MENU_TOKEN@*/) {
            print("Search for locations with query \(searchText)")
            Task { await searchPlaces() }
        }
        .onChange(of: mapSelection,
                  {oldValue, newValue in //if not null muestra
            showDetails = newValue != nil
        })
        .sheet(isPresented: $showDetails, content: {
            LocationDetail(mapSelection: $mapSelection, show: $showDetails)
                .presentationDetents([.height(340)])
                .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                .presentationCornerRadius(12)
        })
        .mapControls{
            MapCompass()
            MapPitchToggle()
            MapUserLocationButton()
        }
    }
    func searchPlaces() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = .userRegion
        
        let results = try? await MKLocalSearch(request: request).start()
        self.results = results?.mapItems ?? []
    }
}

extension CLLocationCoordinate2D{
    static var userLocation: CLLocationCoordinate2D{
        return .init(latitude: 4.6023629365926,
                     longitude: -74.06629875229713)
        
    }
}
extension MKCoordinateRegion{
    static var userRegion: MKCoordinateRegion{
        return .init(center: .userLocation,
                     latitudinalMeters: 10000,
                     longitudinalMeters: 10000)
    }
}


#Preview {
    MapView2()
}
