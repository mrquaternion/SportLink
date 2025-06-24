//
//  LocationManager.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-21.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    // MARK: Singleton
    static let shared = LocationManager()
    // MARK: Objet qui permet d'avoir accès aux services de localisation
    private let locationManager = CLLocationManager()
    // MARK: Objet qui assure la continuation sans violation de la localisation utilisateur
    private var continuation: CheckedContinuation<CLLocation, Error>?
    
    // MARK: Mise en place le délégué (assistant qui se fait informé par CLLocationManager)
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    enum LocationManagerError: String, Error {
        case replaceContinuation = "La continuation a été remplacée."
        case locationNotFound = "Aucun emplacement utilisateur a été trouvé."
    }
    
    func checkAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            return
        }
    }
    
    // MARK: Faire une requête asynchrone de la localisation asynchrone
    var currentLocation: CLLocation {
        get async throws {
            // Vérifie si une contination est déjà en cours
            if self.continuation != nil {
                // Si oui, lance une erreur et la supprime
                self.continuation?.resume(throwing: LocationManagerError.replaceContinuation)
                self.continuation = nil
            }
        
            return try await withCheckedThrowingContinuation { continuation in
                // Mise en place de l'objet de continuation et trigger la maj de la localisation utilisateur
                self.continuation = continuation
                locationManager.requestLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            // Si une localisation est disponible
            if let lastLocation = locations.last {
                // Reprendre l'objet du continuation avec la localisaiton utilisateur comme résultat
                continuation?.resume(returning: lastLocation)
                continuation = nil
            } else {
                continuation?.resume(throwing: LocationManagerError.locationNotFound)
            }
        }
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Lancer une erreur si impossible de récupérer la localisation
        continuation?.resume(throwing: error)
        continuation = nil
    }
}


extension UserDefaults {
    private enum Cles {
        static let derniereLatitude = "derniereLatitude"
        static let derniereLongitude = "derniereLongitude"
    }
    
    var dernierePosition: CLLocationCoordinate2D? {
        get {
            let lat = double(forKey: Cles.derniereLatitude)
            let lon = double(forKey: Cles.derniereLongitude)
            return (lat != 0 && lon != 0) ? CLLocationCoordinate2D(latitude: lat, longitude: lon) : nil
        }
        set {
            if let nvValeur = newValue {
                set(nvValeur.latitude, forKey: Cles.derniereLatitude)
                set(nvValeur.longitude, forKey: Cles.derniereLongitude)
            }
        }
    }
}
