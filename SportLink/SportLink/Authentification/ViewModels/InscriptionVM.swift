//
//  InscriptionVM.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-25.
//

import Foundation
import SwiftUI

@MainActor
final class InscriptionVM: ObservableObject {
    // Email & mot de passe
    @Published var courriel = ""
    @Published var motDePasse = ""
    @Published var motDePasseConfirme = ""
    
    // Info profil
    @Published var nomUtilisateur = ""
    @Published var sportsFavoris: [String] = []
    @Published var disponibilites: [String: [(Date, Date)]] = [:]
    @Published var photo: UIImage? = nil

    
    @Published var nomUtilisateurErreur: String? = nil
    @Published var courrielErreur: String? = nil
    @Published var motDePasseErreur: String? = nil
    @Published var motDePasseConfirmeeErreur: String? = nil
    
    // Firebase Auth
    func inscriptionFirebase() async -> Bool {
        guard verifierChampsDeTexte() else { return false }
        
        do {
            let utilisateur = try await GestionnaireAuthentification.partage.creerUtilisateur(courriel: courriel, motDePasse: motDePasse)
            print("Inscription réussie : \(utilisateur)")
            return true
        } catch {
            print("Échec de l'inscription : \(error.localizedDescription)")
            courrielErreur = "this email is already in use".localizedFirstCapitalized
            return false
        }
    }
    
    func resetErreurs() {
        nomUtilisateurErreur = nil
        courrielErreur = nil
        motDePasseErreur = nil
        motDePasseConfirmeeErreur = nil
    }
    
    private func verifierChampsDeTexte() -> Bool {
        nomUtilisateurErreur = nil
        courrielErreur = nil
        motDePasseErreur = nil
        motDePasseConfirmeeErreur = nil
        
        // Nom utilisateur
        if nomUtilisateur.isEmpty {
            nomUtilisateurErreur = "please enter a valid username".localizedFirstCapitalized
        }
        // Courriel
        if courriel.isEmpty {
            courrielErreur = "please enter a valid email".localizedFirstCapitalized
        }
        // Mot de passe
        if motDePasse.count < 6 {
            motDePasseErreur = "password must be at least 6 characters".localizedFirstCapitalized
        }
        if motDePasse.isEmpty {
            motDePasseErreur = "please enter a valid password".localizedFirstCapitalized
        }
        // Mot de passe confirmation
        if motDePasseConfirme.isEmpty {
            motDePasseConfirmeeErreur = "please confirm your password".localizedFirstCapitalized
        } else if motDePasseConfirme != motDePasse {
            motDePasseConfirmeeErreur = "confirmed password must be the same as password".localizedFirstCapitalized
        }
        
        return nomUtilisateurErreur == nil
            && courrielErreur == nil
            && motDePasseErreur == nil
            && motDePasseConfirmeeErreur == nil
    }
    
    func enregistrementProfil() {
        Task {
            do {
                try await GestionnaireAuthentification.partage.enregistrerProfil(
                    nomUtilisateur: nomUtilisateur,
                    sports: sportsFavoris,
                    disponibilites: disponibilites,
                    photo: photo
                )
            } catch {
                print("Erreur enregistrement profil : \(error.localizedDescription)")
            }
        }
    }
}
