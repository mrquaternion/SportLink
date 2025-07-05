//
//  Parc.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-15.
//

import Foundation
import MapKit

struct Parc: Identifiable {
    var id = UUID().uuidString
    
    let index: String
    let nom: String?
    let limites: [CLLocationCoordinate2D]
    let idsInfra : [String]
}
