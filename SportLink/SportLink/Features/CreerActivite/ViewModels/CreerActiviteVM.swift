//
//  CreerActiviteVueModele.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-06.
//

import Foundation
import SwiftUI
import MapKit

class CreerActiviteVM: ObservableObject {
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
    
    @StateObject var serviceActivites = ServiceActivites()
    private let gestionnaireLocalisation = GestionnaireLocalisation.instance
    private let locParDefaut = CLLocationCoordinate2D(latitude: 45.4215, longitude: -75.6972) // Ottawa fallback
    
    init() {
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
    }

    func genererApercu() {
        let options = MKMapSnapshotter.Options()
        let centre = infraChoisie?.coordonnees ??
        gestionnaireLocalisation.location?.coordinate ?? locParDefaut
        options.region = MKCoordinateRegion(
            center: centre,
            span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125)
        )
        options.size = CGSize(width: 300, height: 150)
        options.scale = UIScreen.main.scale
        options.pointOfInterestFilter = .excludingAll

        MKMapSnapshotter(options: options).start { capture, erreur in
            guard let capture = capture, erreur == nil else { return }
            var image = capture.image

            if let infrastructure = self.infraChoisie {
                let point = capture.point(for: infrastructure.coordonnees)
                UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
                image.draw(at: .zero)

                let configuration = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
                let icone = UIImage(systemName: "mappin.circle.fill", withConfiguration: configuration)?
                    .withTintColor(.red, renderingMode: .alwaysOriginal)

                if let icone = icone {
                    let position = CGPoint(x: point.x - icone.size.width / 2,
                                           y: point.y - icone.size.height)
                    icone.draw(at: position)
                }

                if let imageComposee = UIGraphicsGetImageFromCurrentImageContext() {
                    image = imageComposee
                }
                UIGraphicsEndImageContext()
            }
            self.imageApercu = image
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
        
        // Créer l’activité
        let nvActivite = Activite(
            titre: titre,
            organisateurId: UtilisateurID(valeur: "mockID"), // remplace par le bon ID utilisateur
            infraId: infraChoisie!.id, // unwrappable a cause de la logiuque dans la vue
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
