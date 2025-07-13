//
//  Sport+Extension.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-03.
//

import Foundation
import SwiftUI

enum Sport: String, Decodable, CaseIterable {
    case soccer
    case basketball
    case tennis
    case football
    case volleyball
    case baseball
    case rugby
    case pingpong
    case petanque
    
    var nom: String {
        switch self {
        case .soccer: return "soccer"
        case .basketball: return "basketball"
        case .tennis: return "tennis"
        case .football: return "football"
        case .volleyball: return "volleyball"
        case .baseball: return "balle"
        case .rugby: return "rugby"
        case .pingpong: return "ping-pong"
        case .petanque: return "pétanque"
        }
    }
    
    var icone: String {
        switch self {
        case .soccer: return "soccerball"
        case .basketball: return "basketball.fill"
        case .tennis: return "tennisball.fill"
        case .volleyball: return "volleyball.fill"
        case .baseball: return "baseball.fill"
        case .rugby: return "rugbyball.fill"
        case .football: return "american.football.fill"
        case .pingpong: return "figure.table.tennis"
        case .petanque: return "target"
        }
    }
    
    var emoji: String {
        switch self {
        case .soccer: return "⚽️"
        case .basketball: return "🏀"
        case .tennis: return "🎾"
        case .football: return "🏈"
        case .rugby: return "🏉"
        case .pingpong: return "🏓"
        case .volleyball: return "🏐"
        case .baseball: return "⚾️"
        case .petanque: return "🎯"
        }
    }
    
    var arriereplan: Image {
        let imageStr: String
        switch self {
        case .soccer: imageStr = "soccer"
        case .baseball: imageStr = "baseball"
        case .basketball: imageStr = "basketball"
        case .volleyball: imageStr = "volleyball"
        case .petanque: imageStr = "petanque"
        case .pingpong: imageStr = "pingpong"
        case .football: imageStr = "football"
        case .rugby: imageStr = "football"
        case .tennis: imageStr = "tennis"
        }
        return Image(imageStr + "-min")
    }
}

extension Sport {
    static func depuisNom(_ nom: String) -> Sport {
        return Sport.allCases.first { $0.nom == nom }!
    }
}
