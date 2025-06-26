//
//  Activite.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-14.
//

import Foundation

enum Sport: String, Decodable, CaseIterable {
    case soccer = "soccer"
    case basketball = "basketball"
    case tennis = "tennis"
    case football = "football"
    case volleyball = "volleyball"
    case badminton = "badminton"
    case baseball = "balle"
    case rugby = "rugby"
    case pingpong = "ping-pong"
    case ultimateFrisbee = "ultimate frisbee"
    case petanque = "pétanque"
}

enum StatutActivite: String, Codable {
    case ouvert
    case complet
    case annule
}

struct Activite: Identifiable {
    var id = UUID().uuidString
    let organisateurId : UUID
    let infraId : String
    let sport : Sport
    let horaire : DateInterval
    let nbJoueursRecherches : Int
    let participants : [UUID]
    let statut : StatutActivite
    let invitationsOuvertes : Bool
    let messages : [UUID]
}


