//
//  ActiviteDTO.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-04.
//

import Foundation
import FirebaseFirestore

struct ActiviteDTO: Identifiable, Codable {
    @DocumentID var id: String?
    
    var titre: String
    var organisateurId: String
    var infraId: String
    var sport: String
    var date: PlageHoraire
    var nbJoueursRecherches: Int
    var participants: [String]
    var statut: Int
    var invitationsOuvertes: Bool
    var messages: [String]
}

extension ActiviteDTO {
    func versActivite() throws -> Activite {
        try Activite(
            titre: titre,
            organisateurId: UtilisateurID(valeur: organisateurId),
            infraId: infraId,
            sport: Sport.depuisNom(sport),
            date: date.interval,
            nbJoueursRecherches: nbJoueursRecherches,
            participants: participants.map { UtilisateurID(valeur: $0) },
            statut: StatutActivite(rawValue: statut) ?? .ouvert,
            invitationsOuvertes: invitationsOuvertes,
            messages: messages.map { MessageID(valeur: $0) }
        )
    }
}
