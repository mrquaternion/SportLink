//
//  ConnexionVM.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-27.
//

import Foundation

@MainActor
final class ConnexionVM: ObservableObject {
    @Published var courriel: String = ""
    @Published var motDePasse: String = ""
    
    @Published var courrielErreur: String? = nil
    @Published var motDePasseErreur: String? = nil
    
    func connexionFirebase() async -> EtatAuthentification {
        guard verifierChampsDeTexte() else {
            return .nonAuthentifie
        }
        
        do {
            let utilisateur = try await GestionnaireAuthentification.partage.connecterUtilisateur(
                courriel: courriel,
                motDePasse: motDePasse
            )
            
            print("Connexion réussie : \(utilisateur)")
            return .authentifie
            
        } catch {
            print("Échec de la connexion : \(error.localizedDescription)")
            courrielErreur = "Incorrect username or password. Please check your login details and try again."
            motDePasseErreur = courrielErreur
            return .nonAuthentifie
        }
    }
    
    func resetChampsApresChangementDeVue() {
        courriel = ""
        motDePasse = ""
    }
    
    private func verifierChampsDeTexte() -> Bool {
        courrielErreur = nil
        motDePasseErreur = nil
        
        if courriel.isEmpty {
            courrielErreur = "please enter a valid email".localizedFirstCapitalized
            return false
        }
        
        if !courriel.contains("@") || !courriel.contains(".") {
            courrielErreur = "please enter a valid email format".localizedFirstCapitalized
            return false
        }
        
        if motDePasse.isEmpty {
            motDePasseErreur = "please enter your password".localizedFirstCapitalized
            return false
        }
        
        return true
    }
}
