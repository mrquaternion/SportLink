//
//  File.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-30.
//

import SwiftUI

@MainActor
class ActivitesInscritesVM: ObservableObject {
    let serviceActivites: ServiceActivites
    private let serviceEmplacements: DonneesEmplacementService
    
    @Published var estEnChargement = false
    @Published var activiteSelectionnee: Activite?
    @Published private(set) var activites: [Activite] = []
    
    init(serviceActivites: ServiceActivites, serviceEmplacements: DonneesEmplacementService) {
        self.serviceActivites = serviceActivites
        self.serviceEmplacements = serviceEmplacements
    }
    
    func fetchActivitesInscrites() async {
        estEnChargement = true

        do {
            let utilisateur = try GestionnaireAuthentification.partage.obtenirUtilisateurAuthentifier()
            let uid = utilisateur.uid
            await serviceActivites.fetchActivitesParParticpant(participantId: uid)
            self.activites = serviceActivites.activites
        } catch {
            print("Erreur lors de l'obtention de l'utilisateur : \(error)")
        }
        estEnChargement = false
    }
    
    func bindingActivite(id: String) -> Binding<Activite>? {
        guard let index = activites.firstIndex(where: { $0.id == id }) else { return nil }
        return Binding(
            get: { self.activites[index] },
            set: { self.activites[index] = $0 }
        )
    }
}
