//
//  Emplacement.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-14.
//

import Foundation

struct Infrastructure: Decodable {
    let id : String
    let indexParc : String
    let latitude : Double
    let longitude : Double
    let sport: [Sport]?
}
