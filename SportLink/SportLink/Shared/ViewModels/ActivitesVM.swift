//
//  ActivitesVM.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-17.
//

import Foundation

class ActivitesVM: ObservableObject {
    private let serviceEmplacements: DonneesEmplacementService
    private let gestionnaireLocalisation = GestionnaireLocalisation.instance
    
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
}
