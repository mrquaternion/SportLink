//
//  HostedActivitesVM.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-10.
//


import Foundation

@MainActor
class ActivitesOrganiseesVM: ObservableObject {
    private let serviceActivites: ServiceActivites
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
}
