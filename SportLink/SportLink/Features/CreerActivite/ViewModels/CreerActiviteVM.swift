//
//  CreerActiviteVueModele.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-06.
//

import Foundation
import SwiftUI
import MapKit

@MainActor
class CreerActiviteVM: ObservableObject {
    private let serviceActivites: ServiceActivites
    private let serviceEmplacements: DonneesEmplacementService
    private let gestionnaireLocalisation: GestionnaireLocalisation = GestionnaireLocalisation.instance
    
    @Published var imageApercu: UIImage?
    @Published var titre: String = ""
    @Published var sportSelectionne: Sport = .soccer
    @Published var dateSelectionnee: Date
    @Published var tempsDebut: Date
    @Published var tempsFin: Date
    @Published var dateSelectionneeSelectionTemporaire: Date?
    @Published var tempsDebutSelectionTemporaire: Date?
    @Published var tempsFinSelectionTemporaire: Date?
    @Published var nbParticipants: Int = 0
    @Published var description: String = ""
    @Published var permettreInvitations: Bool = true
    @Published var infraChoisie: Infrastructure? = nil
    @Published var dateMin: Date
    @Published var dateMax: Date
   
    private let locParDefaut = CLLocationCoordinate2D(latitude: 45.4215, longitude: -75.6972) // Ottawa fallback
    
    init(serviceActivites: ServiceActivites, serviceEmplacements: DonneesEmplacementService) {
        let maintenant = Date.now
        let calendrier = Calendar.current
        let heureActuelle = calendrier.component(.hour, from: maintenant)
        let valeurDeBase: Date

        if heureActuelle >= 22 || heureActuelle < 6 {
            let debutAujourdhui = calendrier.startOfDay(for: maintenant)
            let debutDemain = calendrier.date(byAdding: .day, value: 1, to: debutAujourdhui)!
            valeurDeBase = calendrier.date(
                bySettingHour: 6,
                minute: 0,
                second: 0,
                of: debutDemain
            )!
        } else {
            valeurDeBase = maintenant
        }

        self.dateSelectionnee = valeurDeBase
        self.dateSelectionneeSelectionTemporaire = valeurDeBase
        self.dateMin = valeurDeBase
        self.tempsDebut = valeurDeBase
        self.tempsDebutSelectionTemporaire = valeurDeBase
        self.tempsFin = calendrier.date(byAdding: .hour, value: 1, to: valeurDeBase)!
        self.tempsFinSelectionTemporaire = calendrier.date(byAdding: .hour, value: 1, to: valeurDeBase)!
        self.dateMax = calendrier.date(byAdding: .weekOfYear, value: 4, to: valeurDeBase)!
        
        self.serviceActivites = serviceActivites
        self.serviceEmplacements = serviceEmplacements
    }

    @MainActor
    func genererApercu() {
        let options = MKMapSnapshotter.Options()
        
        /* Il y a quatre possibilités :
                1. un centre qui contient la localisation utilisateur et l'infra choisie
                2. un centre qui est seulement la localisation utilisateur
                3. un centre qui est seulement l'infra choisie
                4. un centre par défaut
         */
        
        let utilisateurCoord = gestionnaireLocalisation.location?.coordinate
        let infraCoord = infraChoisie?.coordonnees
        let defautCoord = locParDefaut
        
        let coords: [CLLocationCoordinate2D] = [
            utilisateurCoord,
            infraCoord
        ].compactMap { $0 }
        
        if let region = regionEnglobantPolygone(coords, facteur: 2.0) {
            options.region = region
        } else {
            let centre = utilisateurCoord ?? infraCoord ?? defautCoord
            options.region = MKCoordinateRegion(
                center: centre,
                span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125)
            )
        }
        
        options.size = CGSize(width: 300, height: 150)
        options.scale = UIScreen.main.scale
        options.preferredConfiguration = MKStandardMapConfiguration(emphasisStyle: .muted)
        options.pointOfInterestFilter = .excludingAll
        
        MKMapSnapshotter(options: options).start { capture, erreur in
            guard let capture = capture, erreur == nil else { return }
            let image = capture.image
            
            UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
            
            image.draw(at: .zero)
            
            if let infrastructure = self.infraChoisie { // MERCI CHAT😍
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
                let configurationIcone = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
                let iconeSport = UIImage(systemName: infrastructure.sport.first!.icone, withConfiguration: configurationIcone)?.withTintColor(.white, renderingMode: .alwaysOriginal)
                
                if let iconeSport = iconeSport {
                    let positionIcone = CGPoint(
                        x: centreMarqueur.x - iconeSport.size.width / 2,
                        y: centreMarqueur.y - iconeSport.size.height / 2
                    )
                    iconeSport.draw(at: positionIcone)
                }
            }
            
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
            }
        }
    }
    
    func creerActivite() async {
        // Créer l'intervalle de date
        let calendrier = Calendar.current
        let dateDebut = calendrier.date(bySettingHour: calendrier.component(.hour, from: tempsDebut),
                                        minute: calendrier.component(.minute, from: tempsDebut),
                                        second: 0,
                                        of: dateSelectionnee) ?? dateSelectionnee
        
        let dateFin = calendrier.date(bySettingHour: calendrier.component(.hour, from: tempsFin),
                                      minute: calendrier.component(.minute, from: tempsFin),
                                      second: 0,
                                      of: dateSelectionnee) ?? dateDebut.addingTimeInterval(3600)
        let interval = DateInterval(start: dateDebut, end: dateFin)
        guard let infra = infraChoisie else {
            print("Aucune infrastructure sélectionnée")
            return
        }
        
        // Créer l’activité
        do {
            let utilisateur = try await GestionnaireAuthentification.partage.obtenirUtilisateurAuthentifier()
            let nvActivite = Activite(
                titre: titre,
                organisateurId: UtilisateurID(valeur: utilisateur.uid), // remplace par le bon ID utilisateur
                infraId: infra.id, // unwrappable a cause de la logiuque dans la vue
                sport: sportSelectionne,
                date: interval,
                nbJoueursRecherches: nbParticipants, // unwrappable a cause de la logique dans la vue
                participants: [],
                description: description,
                statut: .ouvert,
                invitationsOuvertes: permettreInvitations, // unwrappable a cause de la logiuque dans la vue
                messages: []
            )
            
            await serviceActivites.sauvegarderActiviteAsync(activite: nvActivite)
        } catch {
            print("Erreur lors de l'enregistrement de l'activité : \(error)")
        }
    }
    
    func existeActivitesDejaCreer() async -> Bool {
        guard let infraId = infraChoisie?.id else { return false }
        let activitesConverties = await serviceActivites.fetchActivitesParInfrastructure(infraId: infraId)
        
        let calendrier = Calendar.current
        let intervalFiltre = DateInterval(start: tempsDebut, end: tempsFin)
        
        let activitesFiltrees = activitesConverties
            .filter { calendrier.isDate($0.date.debut, inSameDayAs: tempsDebut) }
            .filter { activite in
                let intervalAct = DateInterval(start: activite.date.debut, end: activite.date.fin)
                return intervalAct.intersects(intervalFiltre)
            }
        
        if activitesFiltrees.isEmpty {
            return false
        }
        return true
    }
    
    func obtenirDistanceDeUtilisateur(pour infra: Infrastructure?) -> String {
        guard
            let userLoc = gestionnaireLocalisation.location?.coordinate,
            let infraCoords = infra?.coordonnees
        else { return "" }
        
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
    
    // MARK: - Helpers
    var dateEnString: String {
        let f = DateFormatter(); f.dateStyle = .medium; return f.string(from: dateSelectionnee)
    }
    
    var debutDuTempsEnString: String {
        let f = DateFormatter(); f.timeStyle = .short; return f.string(from: tempsDebut)
    }
    
    var finDuTempsEnString: String {
        let f = DateFormatter(); f.timeStyle = .short; return f.string(from: tempsFin)
    }
    
    var texteParticipants: String {
        let nb = nbParticipants
        if nb > 0 {
            return "\(nb) participant\(nb > 1 ? "s" : "")"
        } else {
            return "Number of participants"
        }
    }
    
    var texteInvitations: String {
        return permettreInvitations ? "Open to guests invitations" : "Close to guests invitations"
    }
}
