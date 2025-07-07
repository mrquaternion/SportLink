//
//  UserDefaults+DernierePosition.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-06.
//

import Foundation
import CoreLocation

extension UserDefaults {
    private enum Cles {
        static let latitude = "derniereLatitude"
        static let longitude = "derniereLongitude"
    }
    
    var dernierePosition: CLLocationCoordinate2D? {
        get {
            let lat = double(forKey: Cles.latitude)
            let lon = double(forKey: Cles.longitude)
            return (lat != 0 && lon != 0) ? CLLocationCoordinate2D(latitude: lat, longitude: lon) : nil
        }
        set {
            if let nouvelleValeur = newValue {
                set(nouvelleValeur.latitude, forKey: Cles.latitude)
                set(nouvelleValeur.longitude, forKey: Cles.longitude)
            }
        }
    }
}
