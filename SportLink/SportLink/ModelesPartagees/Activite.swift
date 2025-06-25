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
