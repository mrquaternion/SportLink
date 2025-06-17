//
//  Emplacement.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-14.
//

import Foundation
import MapKit

struct Infrastructure: Identifiable {
    let id : String
    let indexParc : String
    let coordonnees : CLLocationCoordinate2D
    let sport: [Sport]
}
