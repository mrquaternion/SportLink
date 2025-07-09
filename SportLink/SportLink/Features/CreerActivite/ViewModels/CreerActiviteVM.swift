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
    @StateObject var serviceActivites = ServiceActivites()
    private let gestionnaireLocalisation = GestionnaireLocalisation.instance
    private let locParDefaut = CLLocationCoordinate2D(latitude: 45.4215, longitude: -75.6972) // Ottawa fallback
    var infraChoisie: Infrastructure?
    
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
    
    func creerActivite(
        nbParticipants: Int?,
        permettreInvitations: Bool?,
        description: String,
        tempsDebut: Date,
        tempsFin: Date,
        dateSelectionnee: Date,
        titre: String,
        sportSelectionne: Sport
    ) async {
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
            nbJoueursRecherches: nbParticipants!, // unwrappable a cause de la logiuque dans la vue
            participants: [],
            description: description,
            statut: .ouvert,
            invitationsOuvertes: permettreInvitations!, // unwrappable a cause de la logiuque dans la vue
            messages: []
        )
        
        await serviceActivites.sauvegarderActiviteAsync(activite: nvActivite)
    }
    
    func existeActivitesDejaCreer(for infraId: String, debutActivite: Date, finActivite: Date) async -> Bool {
        let activitesConverties = await serviceActivites.fetchActivitesParInfrastructure(infraId: infraId)
        
        let calendrier = Calendar.current
        let intervalFiltre = DateInterval(start: debutActivite, end: finActivite)
        
        let activitesFiltrees = activitesConverties
            .filter { calendrier.isDate($0.date.debut, inSameDayAs: debutActivite) }
            .filter { activite in
                let intervalAct = DateInterval(start: activite.date.debut, end: activite.date.fin)
                return intervalAct.intersects(intervalFiltre)
            }
        
        if activitesFiltrees.isEmpty {
            return false
        }
        return true
    }
}
