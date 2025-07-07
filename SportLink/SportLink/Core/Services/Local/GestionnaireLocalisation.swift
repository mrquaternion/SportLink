//
//  GestionnaireLocalisation.swift
//  SportLink
//
//  Créé par Mathias La Rochelle le 21 juin 2025.
//

import Foundation
import CoreLocation

class GestionnaireLocalisation: NSObject, CLLocationManagerDelegate, ObservableObject {
    // MARK: Singleton
    static let instance = GestionnaireLocalisation()
    
    // MARK: Objet qui donne accès aux services de localisation
    private let gestionnaire = CLLocationManager()
    
    // MARK: Objet de continuation pour la récupération asynchrone
    private var continuation: CheckedContinuation<CLLocation, Error>?
    
    
    // MARK: Position utilisateur disponible en tout temps
    @Published var location: CLLocation? = {
        if let coord = UserDefaults.standard.dernierePosition {
            return CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        }
        return nil
    }()
    
    // MARK: Initialisation avec délégation
    override init() {
        super.init()
        gestionnaire.delegate = self
    }
    
    enum ErreurLocalisation: String, Error {
        case continuationRemplacee = "La continuation a été remplacée."
        case localisationIntrouvable = "Aucune localisation utilisateur trouvée."
    }
    
    func verifierAutorisation() {
        switch gestionnaire.authorizationStatus {
        case .notDetermined:
            gestionnaire.requestWhenInUseAuthorization()
        default:
            return
        }
    }
    
    // MARK: Récupération asynchrone de la position actuelle
    var positionActuelle: CLLocation {
        get async throws {
            if self.continuation != nil {
                self.continuation?.resume(throwing: ErreurLocalisation.continuationRemplacee)
                self.continuation = nil
            }
            
            return try await withCheckedThrowingContinuation { continuation in
                self.continuation = continuation
                gestionnaire.requestLocation()
            }
        }
    }
    
    // MARK: Méthodes déléguées
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let derniere = locations.last {
            continuation?.resume(returning: derniere)
            continuation = nil
        } else {
            continuation?.resume(throwing: ErreurLocalisation.localisationIntrouvable)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
}
