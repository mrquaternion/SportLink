//
//  ExplorerListeVM.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-10.
//

import Foundation
import CoreLocation
import SwiftUI
import Combine

@MainActor
class ExplorerListeVM: ObservableObject {
    @Published var optionTri: OptionTri = .date
    @Published var activites: [Activite] = []
    @Published var activitesTriees: [Activite] = []
    @Published var texteDeRecherche: String = ""
    var service: DonneesEmplacementService
    var gestionnaire = GestionnaireLocalisation()
    
    enum OptionTri { case date, dateInv, distance, distanceInv }
    
    init(service: DonneesEmplacementService) {
        self.service = service
        ajouterSubscriber()
    }
    
    func ajouterSubscriber() {
        $optionTri
            .combineLatest($texteDeRecherche, $activites)
            .map(filtrerEtTrier)
            .assign(to: &$activitesTriees)
    }
    
    private func filtrerEtTrier(par option: OptionTri, pour texte: String, activites: [Activite]) -> [Activite] {
        let activitesFiltrees = filtrer(pour: texte, activites: activites)
        return trier(par: option, activites: activitesFiltrees)
    }
    
    private func trier(par option: OptionTri, activites: [Activite]) -> [Activite] {
        switch option {
        case .date: return activites.sorted { $0.date.debut < $1.date.debut }
        case .dateInv: return activites.sorted { $0.date.debut > $1.date.debut }
        case .distance: return activites.sorted { calculerDistance(activite: $0) < calculerDistance(activite: $1) }
        case .distanceInv: return activites.sorted { calculerDistance(activite: $0) > calculerDistance(activite: $1) }
        }
    }
    
    private func filtrer(pour texte: String, activites: [Activite]) -> [Activite] {
        guard !texte.isEmpty else { return activites }

        let texteNormalise = texte
            .folding(options: .diacriticInsensitive, locale: .current)
            .lowercased()

        return activites.filter { activite in
            guard let parc = obtenirObjetParcAPartirInfra(pour: activite.infraId),
                  let nom = parc.nom else { return false }

            let nomNormalise = nom
                .folding(options: .diacriticInsensitive, locale: .current)
                .lowercased()

            return nomNormalise.contains(texteNormalise)
        }
    }
    
    private func calculerDistance(activite: Activite) -> Double {
        guard
            let userLoc = gestionnaire.location?.coordinate,
            let infraCoords = obtenirObjetInfrastructure(pour: activite.infraId)?.coordonnees
        else { return 0.0 }
        
        let dist = calculerDistanceEntreCoordonnees(
            position1: userLoc,
            position2: infraCoords
        )
        return dist
    }
    
    func obtenirObjetInfrastructure(pour infraId: String) -> Infrastructure? {
        guard let infra = service.infrastructures.first(where: { $0.id == infraId })
        else { return nil }
        return infra
    }
    
    func obtenirObjetParcAPartirInfra(pour infraId: String) -> Parc? {
        guard let infra = obtenirObjetInfrastructure(pour: infraId) else { return nil }
        return service.parcs.first { $0.index == infra.indexParc }
    }
}
