//
//  LocationDetail.swift
//  RideShare
//
//  Created by Cristian Caro on 21/03/24.
//

import SwiftUI
import MapKit

struct LocationDetail: View {
    @Binding var mapSelection: MKMapItem?
    @Binding var show: Bool
    @State private var lookAroundScene: MKLookAroundScene?
    func fetchLookAroundPreview(){
        if let mapSelection {
            lookAroundScene = nil
            Task{
                let request = MKLookAroundSceneRequest(mapItem: mapSelection)
                lookAroundScene = try? await request.scene
            }
        }
    }
    var body: some View {

        
        VStack{
            HStack{
                VStack(alignment: .leading){
                    Text(mapSelection?.placemark.name ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(mapSelection?.placemark.title ?? "")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                        .padding(.trailing)
                }
                Spacer()
                Button{
                    show.toggle()
                    mapSelection=nil
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray, Color(.systemGray6))
                }
            }
            if let scene = lookAroundScene{
                LookAroundPreview(initialScene: scene)
                    . frame(height: 200)
                    .cornerRadius(12)
                    .padding()
            }
            else{
                ContentUnavailableView("No preview available", systemImage: "eye.slash")
            }
        }
        .onAppear{
            fetchLookAroundPreview()
        }
        .onChange(of: mapSelection, {oldValue, newValue in
            fetchLookAroundPreview()})
    }
}

#Preview {
    LocationDetail(mapSelection: .constant(nil), show: .constant(false))
}
