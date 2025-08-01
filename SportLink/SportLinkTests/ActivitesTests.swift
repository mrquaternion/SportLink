//
//  ActiviteTests.swift
//  SportLinkTests
//
//  Created by Mathias La Rochelle on 2025-07-31.
//

import Testing
import Foundation
@testable import SportLink

struct ActivitesTests {
    @Test("Conversion d'objet Activite vers objet DTO fonctionne")
    func activiteVersDTO() {
        let activite = creerMockActivite()
        let dto = activite.versDTO()
        
        #expect(dto.titre == activite.titre)
        #expect(dto.organisateurId == activite.organisateurId.valeur)
        #expect(dto.infraId == activite.infraId)
        #expect(dto.sport == activite.sport)
        #expect(dto.nbJoueursRecherches == activite.nbJoueursRecherches)
        #expect(dto.description == activite.description)
        #expect(dto.statut == activite.statut.rawValue)
        #expect(dto.invitationsOuvertes == activite.invitationsOuvertes)
    }

    private func creerMockActivite(
        titre: String = "Test Activity",
        nbJoueurs: Int = 4,
        participants: [UtilisateurID] = [],
        statut: StatutActivite = .ouvert,
        date: DateInterval? = nil
    ) -> Activite {
        let intervalleDate = date ?? DateInterval(start: Date(), duration: 3600)
        
        return Activite(
            titre: titre,
            organisateurId: UtilisateurID(valeur: "organizer123"),
            infraId: "infra123",
            sport: .soccer,
            date: intervalleDate,
            nbJoueursRecherches: nbJoueurs,
            participants: participants,
            description: "Test activity description",
            statut: statut,
            invitationsOuvertes: true,
            messages: []
        )
    }
}
