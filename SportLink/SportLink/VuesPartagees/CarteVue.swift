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

enum TypeDeCarte: CaseIterable, Hashable {
    case standard
    case hybride
    case satellite
    
    var configuration: MKMapConfiguration {
        switch self {
        case .standard:
            return MKStandardMapConfiguration(elevationStyle: .realistic)
        case .hybride:
            return MKHybridMapConfiguration()
        case .satellite:
            return MKImageryMapConfiguration()
        }
    }
    
    var nomLisible: String {
        switch self {
        case .standard: return "standard"
        case .hybride: return "hybride"
        case .satellite: return "satellite"
        }
    }
}

// MARK: - Vue UIKit intégrée à SwiftUI pour gérer clustering + sélection
struct CarteVue: UIViewRepresentable {
    let parcs: [Parc]
    let infras: [Infrastructure]
    var localisationUtilisateur: CLLocation?
    
    @Binding var centrageInitial: Bool
    @Binding var demandeRecentrage: Bool
    @Binding var parcSelectionne: Parc?
    @Binding var infraSelectionnee: Infrastructure?
    @Binding var aInteragiAvecCarte: Bool
    @Binding var deselectionnerAnnotation: Bool
    @Binding var typeDeCarteSelectionne: TypeDeCarte
    @Binding var filtresSelectionnes: Set<String>

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: Création initiale de la map
    func makeUIView(context: Context) -> MKMapView {
        let mapVue = MKMapView()
        mapVue.delegate = context.coordinator
        mapVue.showsUserLocation = true
        mapVue.showsCompass = false
        
        mapVue.preferredConfiguration = typeDeCarteSelectionne.configuration
        mapVue.pointOfInterestFilter = .excludingAll

        // Enregistrement des vues pour cluster et marqueur
        mapVue.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "marker")
        mapVue.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "cluster")
        
        return mapVue
    }

    // MARK: Mise à jour de la map selon les changements SwiftUI
    func updateUIView(_ uiVue: MKMapView, context: Context) {
        // Recentrer la carte si demandé
        if (centrageInitial || demandeRecentrage), let loc = localisationUtilisateur {
            let region = MKCoordinateRegion(
                center: loc.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )
            uiVue.setRegion(region, animated: true)

            DispatchQueue.main.async {
                self.centrageInitial = false
                self.demandeRecentrage = false
            }
        }
        
        // 1. Filtrer les infrastructures selon les filtres sélectionnés (sauf si "All")
        let infrasFiltrees: [Infrastructure]
        if !filtresSelectionnes.contains("All") {
            infrasFiltrees = infras.filter { infra in
                infra.sport.contains { sport in
                    filtresSelectionnes.contains(sport.nom.capitalized)
                }
            }
        } else {
            infrasFiltrees = infras
        }
        
        // 2. Filtrer les parcs pour ne garder que ceux qui ont au moins une infra filtrée
        let parcsFiltres = parcs.filter { parc in
            // Parcs qui ont au moins une infrastructure filtrée dans leur idsInfra
            let infraIdsDuParc = Set(parc.idsInfra)
            let infraFiltreesIds = Set(infrasFiltrees.map { $0.id })
            return !infraIdsDuParc.intersection(infraFiltreesIds).isEmpty
        }

        // Gestion du polygone du parc sélectionné
        if let parc = parcSelectionne {
            // Nettoyage des marqueurs
            uiVue.removeAnnotations(uiVue.annotations)
            uiVue.removeOverlays(uiVue.overlays)

            // Ajout des marqueurs sauf celui sélectionné
            let parcAnnotations = parcsFiltres
                .filter { $0.id != parcSelectionne?.id }
                .map { ParcAnnotation(parc: $0) }
            uiVue.addAnnotations(parcAnnotations)
            
            let region = regionEnglobantPolygone(parc.limites)
            uiVue.setRegion(region, animated: true)
            
            let polygon = MKPolygon(coordinates: parc.limites, count: parc.limites.count)
            uiVue.addOverlay(polygon)
            
            let infrasParcSelectionne = infrasFiltrees.filter { parc.idsInfra.contains($0.id) }
            let infrasAnnotations = infrasParcSelectionne.map { InfraAnnotation(infra: $0) }
            uiVue.addAnnotations(infrasAnnotations)
        } else {
            uiVue.removeAnnotations(uiVue.annotations)
            uiVue.removeOverlays(uiVue.overlays)

            let parcAnnotations = parcsFiltres.map { ParcAnnotation(parc: $0) }
            uiVue.addAnnotations(parcAnnotations)
        }
        
        if deselectionnerAnnotation {
            for annotation in uiVue.selectedAnnotations {
                uiVue.deselectAnnotation(annotation, animated: false)
            }
            DispatchQueue.main.async {
                deselectionnerAnnotation = false
            }
        }
        
        // Changer de type de carte
        uiVue.preferredConfiguration = typeDeCarteSelectionne.configuration
        uiVue.pointOfInterestFilter = .excludingAll
    }

    // MARK: - Coordinateur pour gérer les callbacks de la MKMapView
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: CarteVue
        let threshold: CLLocationDegrees = 0.025

        init(_ parent: CarteVue) {
            self.parent = parent
        }
        
        // Check avant que le changement commence pour détecter début d'intéraction carte
        func mapView(_ mapVue: MKMapView, regionWillChangeAnimated animated: Bool) {
            DispatchQueue.main.async {
                self.parent.aInteragiAvecCarte = true
            }
        }
        
        // Check si on doit cacher un parc sélectionné à cause d'un zoom out trop grand
        func mapView(_ mapVue: MKMapView, regionDidChangeAnimated animated: Bool) {
            // Limiter le dezoom maximal
            var spanActuel = mapVue.region.span
            let spanMax = MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)
            
            spanActuel.latitudeDelta = min(spanActuel.latitudeDelta, spanMax.latitudeDelta)
            spanActuel.longitudeDelta = min(spanActuel.longitudeDelta, spanMax.longitudeDelta)
            
            if spanActuel.latitudeDelta != mapVue.region.span.latitudeDelta || spanActuel.longitudeDelta != mapVue.region.span.longitudeDelta {
                var nvRegion: MKCoordinateRegion
                if let locUtilisateur = parent.localisationUtilisateur {
                    nvRegion = MKCoordinateRegion(center: locUtilisateur.coordinate, span: spanActuel)
                } else {
                    nvRegion = MKCoordinateRegion(center: mapVue.region.center, span: spanActuel)
                }
                mapVue.setRegion(nvRegion, animated: true)
            }
            
            // Si un parc a été sélectionné
            guard parent.parcSelectionne != nil else { return }

            let liveSpan = mapVue.region.span.latitudeDelta
            let parcSpan = regionEnglobantPolygone(parent.parcSelectionne!.limites).span.longitudeDelta
            if liveSpan > parcSpan * 3 {
                parent.parcSelectionne = nil
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
                parcVue?.glyphImage = UIImage(systemName: "tree.fill")
                parcVue?.markerTintColor = UIColor(red: 123/255.0, green: 171/255.0, blue: 104/255.0, alpha: 1.0)
                parcVue?.clusteringIdentifier = "cluster"
                parcVue?.displayPriority = .defaultHigh
                return parcVue
            }
            
            // Affichage des annotations d'infrastructures
            if let infraAnnotation = annotation as? InfraAnnotation {
                let id = "infrastructure"
                var infraVue = mapVue.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView
                infraVue = infraVue ?? MKMarkerAnnotationView(annotation: infraAnnotation, reuseIdentifier: id)
                infraVue?.annotation = infraAnnotation
                infraVue?.markerTintColor = UIColor(named: "CouleurParDefaut")
                infraVue?.glyphImage = imagePourSports(infraAnnotation.typeDeSport)
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
                parent.parcSelectionne = parcAnnotation.parc

                let region = regionEnglobantPolygone(parcAnnotation.parc.limites)
                mapVue.setRegion(region, animated: true)

                mapVue.removeAnnotation(parcAnnotation)
            }
            
            if let infraAnnotation = vue.annotation as? InfraAnnotation {
                parent.infraSelectionnee = infraAnnotation.infra
                
                let lat = infraAnnotation.coordinate.latitude - mapVue.region.span.longitudeDelta * 0.1
                let lon = infraAnnotation.coordinate.longitude
                let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                                                span: mapVue.region.span)
                mapVue.setRegion(region, animated: true)
            }
        }

        // Rendu du polygone (parc sélectionné)
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polygone = overlay as? MKPolygon {
                let renderer = MKPolygonRenderer(polygon: polygone)
                renderer.fillColor = UIColor.red.withAlphaComponent(0.2)
                renderer.strokeColor = UIColor(named: "CouleurParDefaut")
                renderer.lineWidth = 2
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
