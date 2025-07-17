//
//  CarteParcSeeMore.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-16.
//

import SwiftUI
import MapKit

struct CarteParcSeeMore: UIViewRepresentable {
    let infrastructure: Infrastructure

    class Coordinator: NSObject, MKMapViewDelegate {
        let parent: CarteParcSeeMore

        init(parent: CarteParcSeeMore) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation { return nil }

            if let infraAnnotation = annotation as? InfraAnnotation {
                let id = "infraSeeMore"
                var infraView = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView
                infraView = infraView ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: id)
                infraView?.annotation = annotation
                infraView?.markerTintColor = UIColor(named: "CouleurParDefaut")
                infraView?.glyphImage = imagePourSports(infraAnnotation.typeDeSport)
                return infraView
            }

            return nil
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.delegate = context.coordinator
        map.showsUserLocation = false
        map.isScrollEnabled = false
        map.isZoomEnabled = false
        map.isPitchEnabled = false
        map.isRotateEnabled = false

        map.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "infraSeeMore")

        let annotation = InfraAnnotation(infra: infrastructure)
        map.addAnnotation(annotation)

        let region = MKCoordinateRegion(
            center: infrastructure.coordonnees,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        map.setRegion(region, animated: false)

        return map
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Pas besoin de mise à jour dynamique pour l'instant
    }
}
