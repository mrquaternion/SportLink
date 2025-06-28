//
//  MarqueurVueModele.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-24.
//

import Foundation
import SwiftUI

extension Sport {
    var icone: IconeSport? {
        switch self {
            case .soccer: return .soccer
            case .basketball: return .basketball
            case .volleyball: return .volleyball
            case .tennis: return .tennis
            case .baseball: return .baseball
            case .rugby: return .rugby
            case .football: return .football
            case .pingpong: return .pingpong
            case .badminton: return .badminton
            case .ultimateFrisbee: return .ultimateFrisbee
            case .petanque: return .petanque
        }
    }
}

enum IconeSport: String {
    case soccer = "soccerball"
    case basketball = "basketball.fill"
    case volleyball = "volleyball.fill"
    case tennis = "tennis.racket"
    case baseball = "baseball.fill"
    case rugby = "rugbyball.fill"
    case football = "american.football.fill"
    case pingpong = "figure.table.tennis"
    case badminton = "figure.badminton"
    case ultimateFrisbee = "figure.disc.sports"
    case petanque = "target"
}

func imagePourSports(_ sports: [Sport]) -> UIImage? {
    if sports.count == 1 { // si 1 sport, on retourn l'image
        return UIImage(systemName: sports[0].icone!.rawValue)
    } else { // si 2 ou plus mais il n'y a jamais plus que 2
        let images = sports.compactMap { UIImage(systemName: $0.icone!.rawValue) }

        let size = CGSize(width: 55, height: 55)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        for (index, image) in images.enumerated() {
            let offset = CGFloat(index * 24) // décale légèrement
            image.draw(in: CGRect(x: offset, y: offset, width: 34, height: 34)) // à la diagonale
        }

        let combinees = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return combinees
    }
}
