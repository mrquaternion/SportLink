//
//  HostedActivitesVM.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-10.
//


import Foundation

@MainActor
class ActivitesOrganiseesVM: ObservableObject {
    let serviceActivites: ServiceActivites
    private let serviceEmplacements: DonneesEmplacementService
    private let gestionnaireLocalisation = GestionnaireLocalisation.instance
    
    @Published var estEnChargement = false
    
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
            print("⚠️ Activité avec ID \(idActivite) non trouvée localement.")
        }
    }
}
