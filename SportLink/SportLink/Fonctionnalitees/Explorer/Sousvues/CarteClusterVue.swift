//
//  CarteClusterVue.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-22.
//

import Foundation
import SwiftUI
import MapKit

// MARK: - Annotation personnalisée pour un parc
class ParcAnnotation: NSObject, MKAnnotation {
    let parc: Parc
    var title: String?
    var coordinate: CLLocationCoordinate2D

    init(parc: Parc) {
        self.parc = parc
        self.title = parc.nom
        self.coordinate = centrePolygone(for: parc.limites)
    }
}

// MARK: - Annotation personnalisée pour une infrastructure
class InfraAnnotation: NSObject, MKAnnotation {
    let infra: Infrastructure
    let typeDeSport: [Sport]
    var coordinate: CLLocationCoordinate2D
    
    init(infra: Infrastructure) {
        self.infra = infra
        self.typeDeSport = infra.sport
        self.coordinate = infra.coordonnees
    }
}

// MARK: - Vue UIKit intégrée à SwiftUI pour gérer clustering + sélection
struct CarteClusterVue: UIViewRepresentable {
    let parcs: [Parc]
    let infras: [Infrastructure]
    var localisationUtilisateur: CLLocation?
    var centrerCarte: Bool
    
    @Binding var selectionne: Parc?
    @Binding var recentrer: Bool
    @Binding var aInteragiAvecCarte: Bool


    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: Création initiale de la map
    func makeUIView(context: Context) -> MKMapView {
        let mapVue = MKMapView()
        mapVue.delegate = context.coordinator
        mapVue.showsUserLocation = true
        mapVue.pointOfInterestFilter = .excludingAll

        // Enregistrement des vues pour cluster et marqueur
        mapVue.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "marker")
        mapVue.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "cluster")
        return mapVue
    }

    // MARK: Mise à jour de la map selon les changements SwiftUI
    func updateUIView(_ uiVue: MKMapView, context: Context) {
        // Recentrer la carte si demandé
        if (centrerCarte || recentrer), let loc = localisationUtilisateur {
            let region = MKCoordinateRegion(
                center: loc.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )
            uiVue.setRegion(region, animated: true)

            if recentrer {
                DispatchQueue.main.async {
                    self.recentrer = false // pour éviter de le refaire au prochain update
                }
            }
        }

        // Nettoyage des marqueurs
        uiVue.removeAnnotations(uiVue.annotations)

        // Ajout des marqueurs sauf celui sélectionné
        let annotations = parcs
            .filter { $0.id != selectionne?.id }
            .map { ParcAnnotation(parc: $0) }
        uiVue.addAnnotations(annotations)

        // Gestion du polygone du parc sélectionné
        uiVue.removeOverlays(uiVue.overlays)
        if let parc = selectionne {
            let region = regionEnglobantPolygone(parc.limites)
            uiVue.setRegion(region, animated: true)

            let polygon = MKPolygon(coordinates: parc.limites, count: parc.limites.count)
            uiVue.addOverlay(polygon)
            
            let infrasParcSelectionne = infras.filter { parc.idsInfra.contains($0.id) }
            let infrasAnnotations = infrasParcSelectionne.map { InfraAnnotation(infra: $0) }
            uiVue.addAnnotations(infrasAnnotations)
        }
    }

    // MARK: - Coordinateur pour gérer les callbacks de la MKMapView
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: CarteClusterVue

        init(_ parent: CarteClusterVue) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            DispatchQueue.main.async {
                self.parent.aInteragiAvecCarte = true
            }
        }

        // Fournit une vue personnalisée pour chaque annotation
        func mapView(_ mapVue: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation { return nil }

            // Affichage des clusters
            if let cluster = annotation as? MKClusterAnnotation {
                let id = "cluster"
                var clusterVue = mapVue.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView
                clusterVue = clusterVue ?? MKMarkerAnnotationView(annotation: cluster, reuseIdentifier: id)
                clusterVue?.annotation = cluster
                clusterVue?.markerTintColor = .gray
                clusterVue?.glyphText = "\(cluster.memberAnnotations.count)"
                return clusterVue
            }

            // Affichage des annotations de parcs
            if let parcAnnotation = annotation as? ParcAnnotation {
                let id = "parc"
                var parcVue = mapVue.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView
                parcVue = parcVue ?? MKMarkerAnnotationView(annotation: parcAnnotation, reuseIdentifier: id)
                parcVue?.annotation = parcAnnotation
                parcVue?.glyphImage = UIImage(systemName: "figure.run")
                parcVue?.markerTintColor = UIColor(named: "CouleurParDefaut") ?? .blue
                parcVue?.clusteringIdentifier = "cluster"
                parcVue?.displayPriority = .defaultHigh
                parcVue?.canShowCallout = true
                return parcVue
            }
            
            // Affichage des annotations d'infrastructures
            if let infraAnnotation = annotation as? InfraAnnotation {
                let id = "infrastructure"
                var infraVue = mapVue.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView
                infraVue = infraVue ?? MKMarkerAnnotationView(annotation: infraAnnotation, reuseIdentifier: id)
                infraVue?.annotation = infraAnnotation
                infraVue?.markerTintColor = .blue
                infraVue?.glyphImage = UIImage(systemName: infraAnnotation.typeDeSport[0].icone!.rawValue)
                return infraVue
            }

            return nil
        }

        func mapView(_ mapVue: MKMapView, didSelect vue: MKAnnotationView) {
            if let cluster = vue.annotation as? MKClusterAnnotation {
                // Extraire les coordonnées de tous les marqueurs dans le cluster
                let coordinates = cluster.memberAnnotations.map { $0.coordinate }

                // Calculer la région englobante de tous les membres du cluster
                let region = regionEnglobantPolygone(coordinates)
                mapVue.setRegion(region, animated: true)
                return
            }

            if let parcAnnotation = vue.annotation as? ParcAnnotation {
                parent.selectionne = parcAnnotation.parc

                let region = regionEnglobantPolygone(parcAnnotation.parc.limites)
                mapVue.setRegion(region, animated: true)

                mapVue.removeAnnotation(parcAnnotation)
            }
        }


        // Rendu du polygone (parc sélectionné)
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polygone = overlay as? MKPolygon {
                let renderer = MKPolygonRenderer(polygon: polygone)
                renderer.fillColor = UIColor.red.withAlphaComponent(0.4)
                renderer.strokeColor = UIColor.red
                renderer.lineWidth = 2
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

extension Sport {
    var icone: IconeSport? {
        switch self {
            case .soccer: return .soccer
            case .basketball: return .basketball
            case .volleyball: return .volleyball
            case .tennis: return .tennis
            case .baseball: return .baseball
            case .rugby: return .rugby
            case .football: return .football
            case .pingpong: return .pingpong
            case .badminton: return .badminton
            case .ultimateFrisbee: return .ultimateFrisbee
            case .petanque: return .petanque
        }
    }
}
