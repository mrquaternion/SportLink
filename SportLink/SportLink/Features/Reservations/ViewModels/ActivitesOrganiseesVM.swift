//
//  HostedActivitesVM.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-10.
//

import SwiftUI
import Foundation
import FirebaseFirestore

@MainActor
class ActivitesOrganiseesVM: ObservableObject {
    let serviceActivites: ServiceActivites
    private let serviceEmplacements: DonneesEmplacementService
    
    @Published var estEnChargement = false
    @Published var activiteSelectionnee: Activite?
    @Published private(set) var activites: [Activite] = []
    
    init(serviceActivites: ServiceActivites, serviceEmplacements: DonneesEmplacementService) {
        self.serviceActivites = serviceActivites
        self.serviceEmplacements = serviceEmplacements
    }
    
    func chargerActivitesParOrganisateur(organisateurId: String) async {
        estEnChargement = true
        await serviceActivites.fetchActivitesParOrganisateur(organisateurId: organisateurId)
        self.activites = serviceActivites.activites
        estEnChargement = false
    }
    
    func mettreAJourTitreLocalement(idActivite: String, nouveauTitre: String) {
        if let index = activites.firstIndex(where: { $0.id == idActivite }) {
            activites[index].titre = nouveauTitre
        } else {
            print("Activité avec ID \(idActivite) non trouvée localement.")
        }
    }
    func bindingActivite(id: String) -> Binding<Activite>? {
        guard let index = activites.firstIndex(where: { $0.id == id }) else { return nil }
        return Binding(
            get: { self.activites[index] },
            set: { self.activites[index] = $0 }
        )
    }
    func mettreAJourDateLocalement(idActivite: String, nouvelleDate: PlageHoraire) {
        if let index = activites.firstIndex(where: { $0.id == idActivite }) {
            activites[index].date = nouvelleDate
        } else {
            print("Activité avec ID \(idActivite) non trouvée localement.")
        }
    }
    
    func mettreAJourNbJoueursRecherchesLocalement(idActivite: String, nb: Int) {
        if let index = activites.firstIndex(where: { $0.id == idActivite }) {
            activites[index].nbJoueursRecherches = nb
        } else {
            print("Activité avec ID \(idActivite) non trouvée localement pour maj joueurs.")
        }
    }
    
    func mettreAJourAutorisationInvitationsLocalement(idActivite: String, autorise: Bool) {
        if let index = activites.firstIndex(where: { $0.id == idActivite }) {
            activites[index].invitationsOuvertes = autorise
        } else {
            print("Activité avec ID \(idActivite) non trouvée localement.")
        }
    }
    
    func mettreAJourDescriptionLocalement(idActivite: String, nouvelleDescription: String) {
        guard let index = activites.firstIndex(where: { $0.id == idActivite }) else { return }
        activites[index].description = nouvelleDescription
    }
}
