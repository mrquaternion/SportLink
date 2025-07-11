//
//  FonctionsAux.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-10.
//

import Foundation
import MapKit

func calculerDistanceEntreCoordonnees(position1: CLLocationCoordinate2D, position2: CLLocationCoordinate2D) -> Double {
    // In KM
    let distance_in_meters = MKMapPoint(position1).distance(to: MKMapPoint(position2))
    return distance_in_meters / 1_000.0
}
