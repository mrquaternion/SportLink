//
//  ActivitesVM.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-17.
//

import Foundation
import MapKit
import SwiftUI

@MainActor
class ActivitesVM: ObservableObject {
    private let serviceEmplacements: DonneesEmplacementService
    private let gestionnaireLocalisation = GestionnaireLocalisation.instance
    
    @Published var imageApercu: UIImage?
    
    init(serviceEmplacements: DonneesEmplacementService) {
        self.serviceEmplacements = serviceEmplacements
    }
    
    func obtenirDistanceDeUtilisateur(pour activite: Activite) -> String {
        guard
            let userLoc = gestionnaireLocalisation.location?.coordinate,
            let infraCoords = serviceEmplacements.obtenirObjetInfrastructure(pour: activite.infraId)?.coordonnees
        else {
            return ""
        }
        
        let dist = calculerDistanceEntreCoordonnees(
            position1: userLoc,
            position2: infraCoords
        )
        
        if dist < 1 {
            let distConvertie = dist * 1000
            return String(format: "%d m", Int(distConvertie))
        } else {
            return String(format: "%.1f km", dist)
        }
    }
    
    func obtenirInfraEtParc(infraId: String) -> (Infrastructure?, Parc?) {
        let parcDeActiviteSelectionnee = serviceEmplacements.obtenirObjetParcAPartirInfra(pour: infraId)
        let infraDeActiviteSelectionnee = serviceEmplacements.obtenirObjetInfrastructure(pour: infraId)
        
        return (infraDeActiviteSelectionnee, parcDeActiviteSelectionnee)
    }
    
    func genererApercu(infraId: String) async -> Bool {
        await withCheckedContinuation { continuation in
            let options = MKMapSnapshotter.Options()
            
            /* Il y a quatre possibilités :
                    1. un centre qui contient la localisation utilisateur et l'infra choisie
                    2. un centre qui est seulement la localisation utilisateur
                    3. un centre qui est seulement l'infra choisie
                    4. un centre par défaut
             */
            
            let utilisateurCoord = gestionnaireLocalisation.location?.coordinate
            let infrastructure = serviceEmplacements.obtenirObjetInfrastructure(pour: infraId)!
            
            let coords: [CLLocationCoordinate2D] = [
                utilisateurCoord,
                infrastructure.coordonnees
            ].compactMap { $0 }
            
            if let region = regionEnglobantPolygone(coords, facteur: 2.0) {
                options.region = region
            } else {
                let centre = utilisateurCoord ?? infrastructure.coordonnees
                options.region = MKCoordinateRegion(
                    center: centre,
                    span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
                )
            }
            
            options.size = CGSize(width: UIScreen.main.bounds.width-40, height: 240) // -40 est pour retirer 20px de chaque coté une fois dans la vue
            options.scale = UIScreen.main.scale
            options.preferredConfiguration = MKStandardMapConfiguration(emphasisStyle: .muted)
            options.pointOfInterestFilter = .excludingAll
        
            MKMapSnapshotter(options: options).start(with: .main) { capture, erreur in
                guard let capture = capture, erreur == nil else { return }
                let image = capture.image
                
                UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
                
                image.draw(at: .zero)
                
                // MARK: INFRASTRUCTURE
                let pointInfra = capture.point(for: infrastructure.coordonnees)
                
                // Dimensions du marqueur
                let largeurMarqueur: CGFloat = 40
                let hauteurMarqueur: CGFloat = 27
                let rayonCercle: CGFloat = 12
                
                let context = UIGraphicsGetCurrentContext()
                context?.setShadow(offset: CGSize(width: 0, height: 2), blur: 4, color: UIColor.black.withAlphaComponent(0.3).cgColor)
                
                // Position du marqueur (centré horizontalement, pointe vers le bas)
                let positionMarqueur = CGPoint(
                    x: pointInfra.x - largeurMarqueur / 2,
                    y: pointInfra.y - hauteurMarqueur
                )
                
                // Créer le chemin du marqueur
                let cheminMarqueur = UIBezierPath()
                let centreMarqueur = CGPoint(
                    x: positionMarqueur.x + largeurMarqueur / 2,
                    y: positionMarqueur.y + rayonCercle
                )
                
                // Cercle supérieur
                cheminMarqueur.addArc(
                    withCenter: centreMarqueur,
                    radius: rayonCercle,
                    startAngle: 0,
                    endAngle: .pi * 2,
                    clockwise: true
                )
                
                // Pointe vers le bas
                cheminMarqueur.move(to: CGPoint(x: centreMarqueur.x - 3, y: centreMarqueur.y + rayonCercle))
                cheminMarqueur.addLine(to: CGPoint(x: centreMarqueur.x, y: positionMarqueur.y + hauteurMarqueur))
                cheminMarqueur.addLine(to: CGPoint(x: centreMarqueur.x + 3, y: centreMarqueur.y + rayonCercle))
                cheminMarqueur.close()
                
                // Dessiner le marqueur
                UIColor.red.setFill()
                cheminMarqueur.fill()
                                
                context?.setShadow(offset: .zero, blur: 0, color: nil)
                
                // Dessiner l'icône du sport à l'intérieur
                let configurationIcone = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
                let iconeSport = UIImage(systemName: infrastructure.sport.first!.icone, withConfiguration: configurationIcone)?.withTintColor(.white, renderingMode: .alwaysOriginal)
                
                if let iconeSport = iconeSport {
                    let positionIcone = CGPoint(
                        x: centreMarqueur.x - iconeSport.size.width / 2,
                        y: centreMarqueur.y - iconeSport.size.height / 2
                    )
                    iconeSport.draw(at: positionIcone)
                }
                
                // MARK: UTILISATEUR
                if let utilisateur = self.gestionnaireLocalisation.location { // MERCI CHAT😍
                    let pointUtilisateur = capture.point(for: utilisateur.coordinate)
                    
                    let rayonExterne: CGFloat = 10
                    let rayonInterne: CGFloat = 7
                    
                    let centreUtilisateur = CGPoint(x: pointUtilisateur.x, y: pointUtilisateur.y)
                    
                    let context = UIGraphicsGetCurrentContext()
                    context?.setShadow(offset: CGSize(width: 0, height: 2), blur: 4, color: UIColor.black.withAlphaComponent(0.3).cgColor)
                                                        
                    // Cercle externe blanc
                    let cercleExterne = CGRect(
                        x: centreUtilisateur.x - rayonExterne,
                        y: centreUtilisateur.y - rayonExterne,
                        width: rayonExterne * 2,
                        height: rayonExterne * 2
                    )
                    
                    // Cercle interne rouge
                    let cercleInterne = CGRect(
                        x: centreUtilisateur.x - rayonInterne,
                        y: centreUtilisateur.y - rayonInterne,
                        width: rayonInterne * 2,
                        height: rayonInterne * 2
                    )
                    
                    // Dessiner le cercle externe blanc
                    UIColor.systemGray6.setFill()
                    UIBezierPath(ovalIn: cercleExterne).fill()
                    
                    // Dessiner le cercle interne rouge
                    UIColor.red.setFill()
                    UIBezierPath(ovalIn: cercleInterne).fill()
                    
                    context?.setShadow(offset: .zero, blur: 0, color: nil)
                }
                
                // Récupérer l'image finale
                let imageFinale = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                Task {
                    self.imageApercu = imageFinale
                    continuation.resume(returning: imageFinale != nil)
                }
            }
        }
    }
    
    func dateAAffichee(_ date: Date) -> String {
        let calendrier = Calendar.current
        
        let jourDeSemaineFormat = DateFormatter()
        jourDeSemaineFormat.locale = Locale.current
        jourDeSemaineFormat.dateFormat = "EEEE"
        
        let jourDuMoisFormat = DateFormatter()
        jourDuMoisFormat.locale = Locale.current
        jourDuMoisFormat.dateFormat = "MMMM d"
 
        let jourDeSemaine: String
        if calendrier.isDateInToday(date) {
            jourDeSemaine = "Today"
        } else if calendrier.isDateInTomorrow(date) {
            jourDeSemaine = "Tomorrow"
        } else {
            jourDeSemaine = jourDeSemaineFormat.string(from: date)
        }
        
        let jourDuMois = jourDuMoisFormat.string(from: date)
        return "\(jourDeSemaine), \(jourDuMois)"
    }
    
    func obtenirPhotoEtNomParticipants(participantIds: [UtilisateurID], serviceUtilisateurs: ServiceUtilisateurs) async -> [(Image, String)] {
        var nomTrieesParNbCharacteres: [(Image, String)] = []
     
        for uid in participantIds {
            let (nomOpt, uiImageOpt) = await serviceUtilisateurs.fetchInfoUtilisateur(pour: uid.valeur)
            let image = uiImageOpt.map { Image(uiImage: $0) } ?? Image(systemName: "person.crop.circle.fill")
            let nom = nomOpt?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false ? nomOpt! : "Inconnu"
            nomTrieesParNbCharacteres.append((image, nom))
        }
        
        return nomTrieesParNbCharacteres.sorted { $0.1.count < $1.1.count }
    }
    
    
    func chercherSiActiviteEstEnFavoris(pour activite: Activite) -> Bool {
        return true
    }
}
