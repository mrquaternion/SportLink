//
//  Utilisateur.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-14.
//

import Foundation

struct Utilisateur: Identifiable {
    var id: String { nomUtilisateur }
    
    let nomUtilisateur: String
    let courriel: String
    var photoProfil: String // URL
    var disponibilites: [Int : [String]] // où 1 = Lundi, 2 = Mardi, ..., 7 = Dimanche
    var sportsFavoris: [Sport]
    var activitesFavoris: [ActiviteID]
    var partenairesRecents: [UtilisateurID]
}

struct UtilisateurID: Hashable, Codable {
    let valeur: String
}

extension String {
    var enUtilisateurID: UtilisateurID {
        UtilisateurID(valeur: self)
    }
}

extension Utilisateur {
    func estUnFavoris(for activiteId: ActiviteID) -> Bool {
        return activitesFavoris.contains(where: { $0.valeur == activiteId.valeur })
    }
}
