//
//  CarteParcSeeMore.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-16.
//

//
//  CarteParcSeeMore.swift
//  SportLink
//
//  Created by [TonNom] on [Date].
//

import SwiftUI
import MapKit

struct CarteParcSeeMore: View {
    let coordonneesParc: CLLocationCoordinate2D
    @State private var region: MKCoordinateRegion

    init(coordonneesParc: CLLocationCoordinate2D) {
        self.coordonneesParc = coordonneesParc
        _region = State(initialValue: MKCoordinateRegion(
            center: coordonneesParc,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [coordonneesParc]) { coord in
            MapMarker(coordinate: coord, tint: .blue)
        }
        .frame(height: 300)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// Extension pour rendre CLLocationCoordinate2D conforme à Identifiable
extension CLLocationCoordinate2D: Identifiable {
    public var id: String {
        "\(latitude)-\(longitude)"
    }
}
