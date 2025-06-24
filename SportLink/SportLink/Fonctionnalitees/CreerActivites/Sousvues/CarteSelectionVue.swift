//
//  CarteSelectionVue.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-06-22.
//

import SwiftUI
import MapKit
import CoreLocation

struct CarteSelectionVue: View {
    @Binding var selectedLocation: CLLocationCoordinate2D?

    // Calculs de coordonnées
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 45.5019, longitude: -73.5674),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    // Afficher la carte
    @State private var cameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 45.5019, longitude: -73.5674),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    )

    var body: some View {
        VStack(spacing: 4) {
            // Carte
            ZStack {
                Map(position: $cameraPosition) {
                    if let location = selectedLocation {
                        Annotation("Marqueur", coordinate: location) {
                            MarqueurParc()
                        }
                    }
                }
                .mapStyle(.standard)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.red, lineWidth: 3)
                )
                .frame(height: 140)
                .overlay(
                    GeometryReader { geometry in
                        Color.clear
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onEnded { value in
                                        let tapLocation = value.location
                                        let size = geometry.size
                                        let center = region.center
                                        let span = region.span

                                        let lat = center.latitude + Double(tapLocation.y - size.height / 2) / size.height * -span.latitudeDelta
                                        let lon = center.longitude + Double(tapLocation.x - size.width / 2) / size.width * span.longitudeDelta

                                        selectedLocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                                    }
                            )
                    }
                )
            }

            // Texte en dessous de la carte
            if selectedLocation == nil {
                Text("Click on the map to select a marker")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 4)
            }
        }
        .padding(.horizontal)
    }
}


