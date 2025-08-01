//
//  ActivitesRecommandeesVM.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-25.
//

import Foundation

@MainActor
class ActivitesRecommandeesVM: ObservableObject {
    let serviceActivites: ServiceActivites
    private let serviceEmplacements: DonneesEmplacementService
    
    @Published var estEnChargement = false
    @Published private(set) var activites: [Activite] = []
    
    init(serviceActivites: ServiceActivites, serviceEmplacements: DonneesEmplacementService) {
        self.serviceActivites = serviceActivites
        self.serviceEmplacements = serviceEmplacements
    }
    
    func chargerActivitesParPreference(organisateurId: String) async {
        estEnChargement = true
        await serviceActivites.fetchActivitesParOrganisateur(organisateurId: organisateurId)
        self.activites = serviceActivites.activites
        estEnChargement = false
    }
}
