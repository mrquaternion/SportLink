//
//  Activite.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-14.
//

import Foundation

enum Sport: String, Decodable, CaseIterable {
    case soccer
    case basketball
    case tennis
    case football
    case volleyball
    case badminton
    case baseball
    case rugby
    case pingpong
    case ultimateFrisbee
    case petanque
    
    var nom: String {
        switch self {
        case .soccer: return "soccer"
        case .basketball: return "basketball"
        case .tennis: return"tennis"
        case .football: return "football"
        case .volleyball: return"volleyball"
        case .badminton: return "badminton"
        case .baseball: return "balle"
        case .rugby: return "rugby"
        case .pingpong: return "ping-pong"
        case .ultimateFrisbee: return "ultimate frisbee"
        case .petanque: return "pétanque"
        }
    }
    
    var icone: String {
        switch self {
        case .soccer: return "soccerball"
        case .basketball: return "basketball.fill"
        case .volleyball: return "volleyball.fill"
        case .tennis: return "tennis.racket"
        case .baseball: return "baseball.fill"
        case .rugby: return "rugbyball.fill"
        case .football: return "american.football.fill"
        case .pingpong: return "figure.table.tennis"
        case .badminton: return "figure.badminton"
        case .ultimateFrisbee: return "figure.disc.sports"
        case .petanque: return "target"
        }
    }
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


