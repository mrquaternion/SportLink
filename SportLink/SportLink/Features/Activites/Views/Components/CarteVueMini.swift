//
//  CarteVueMini.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-16.
//

import SwiftUI
import MapKit

struct CarteVueMini: View {
    let infrastructure: Infrastructure

    var body: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(
            center: infrastructure.coordonnees,
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )), annotationItems: [infrastructure]) { infra in
            MapAnnotation(coordinate: infra.coordonnees) {
                ZStack {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 25, height: 25)
                        .shadow(radius: 3)
                    Image(systemName: infra.sport.first?.icone ?? "questionmark.circle")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .bold))
                }
            }
        }
        .frame(height: 180)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
