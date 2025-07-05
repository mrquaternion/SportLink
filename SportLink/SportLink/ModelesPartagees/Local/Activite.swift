//
//  Activite.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-14.
//

import Foundation
import FirebaseFirestore

enum StatutActivite: Int, Codable {
    case ouvert = 0
    case complet = 1
    case annule = 2
}

enum ActiviteErreur: Error {
    case titreTropLong
}

struct ActiviteID: Hashable, Codable {
    let valeur: UUID
}

struct PlageHoraire: Codable {
    let debut: Date
    let fin: Date
    
    var interval: DateInterval {
        DateInterval(start: debut, end: fin)
    }
}

struct Activite: Identifiable, Codable {
    @DocumentID var id: String?
    
    var titre: String
    let organisateurId: UtilisateurID
    let infraId: String
    let sport: String
    var date: PlageHoraire
    var nbJoueursRecherches: Int
    var participants: [UtilisateurID]
    var statut: Int
    var invitationsOuvertes: Bool
    var messages: [MessageID]
    
    init(
        titre: String,
        organisateurId: UtilisateurID,
        infraId: String,
        sport: Sport,
        date: DateInterval,
        nbJoueursRecherches: Int,
        participants: [UtilisateurID],
        statut: StatutActivite,
        invitationsOuvertes: Bool,
        messages: [MessageID]
    ) throws {
        guard titre.count <= 25 else {
            throw ActiviteErreur.titreTropLong
        }
        
        self.titre = titre
        self.organisateurId = organisateurId
        self.infraId = infraId
        self.sport = sport.nom
        self.date = PlageHoraire(debut: date.start, fin: date.end)
        self.nbJoueursRecherches = nbJoueursRecherches
        self.participants = participants
        self.statut = statut.rawValue
        self.invitationsOuvertes = invitationsOuvertes
        self.messages = messages
    }
    
    // Init interne sans validation
    private init(
        id: String,
        titre: String,
        organisateurId: UtilisateurID,
        infraId: String,
        sport: String,
        date: PlageHoraire,
        nbJoueursRecherches: Int,
        participants: [UtilisateurID],
        statut: Int,
        invitationsOuvertes: Bool,
        messages: [MessageID]
    ) {
        self.id = id
        self.titre = titre
        self.organisateurId = organisateurId
        self.infraId = infraId
        self.sport = sport
        self.date = date
        self.nbJoueursRecherches = nbJoueursRecherches
        self.participants = participants
        self.statut = statut
        self.invitationsOuvertes = invitationsOuvertes
        self.messages = messages
    }
}

extension Activite {
    // Factory method depuis Firestore
    static func depuisFirestore(
        id: String,
        titre: String,
        organisateurId: String,
        infraId: String,
        sport: String,
        debut: Date,
        fin: Date,
        nbJoueursRecherches: Int,
        participants: [String],
        statut: Int,
        invitationsOuvertes: Bool,
        messages: [String]
    ) -> Activite {
        Activite(
            id: id,
            titre: titre,
            organisateurId: UtilisateurID(valeur: organisateurId),
            infraId: infraId,
            sport: sport,
            date: PlageHoraire(debut: debut, fin: fin),
            nbJoueursRecherches: nbJoueursRecherches,
            participants: participants.map { UtilisateurID(valeur: $0) },
            statut: statut,
            invitationsOuvertes: invitationsOuvertes,
            messages: messages.map { MessageID(valeur: $0) }
        )
    }
    
    func versDTO() -> ActiviteDTO {
        ActiviteDTO(
            id: id,
            titre: titre,
            organisateurId: organisateurId.valeur,
            infraId: infraId,
            sport: sport,
            date: date,
            nbJoueursRecherches: nbJoueursRecherches,
            participants: participants.map { $0.valeur },
            statut: statut,
            invitationsOuvertes: invitationsOuvertes,
            messages: messages.map { $0.valeur }
        )
    }
    
    func obtenirPlageHoraireStr() -> (String, String) {
        let format = DateFormatter()
        format.timeStyle = .short
        format.dateStyle = .none

        let heureDebut = format.string(from: date.debut)
        let heureFin = format.string(from: date.fin)
        
        return (heureDebut, heureFin)
    }
}

