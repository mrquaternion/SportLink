//
//  ServiceUtilisateurs.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-30.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

@MainActor
class ServiceUtilisateurs: ObservableObject {
    func fetchInfoUtilisateur(pour uid: String) async -> (String?, UIImage?) {
        do {
            let ref = Firestore.firestore()
                .collection("utilisateurs")
                .document(uid)
            let snapshot = try await ref.getDocument()
            
            guard
                let data = snapshot.data(),
                let nomUtilisateur = data["nomUtilisateur"] as? String
            else {
                return (nil, nil)
            }
            
            var photo: UIImage? = nil
            if let urlString = data["photoUrl"] as? String,
               let url = URL(string: urlString) {
                do {
                    let (rawData, _) = try await URLSession.shared.data(from: url)
                    photo = UIImage(data: rawData)
                } catch {
                    print("Erreur téléchargement photo pour \(uid): \(error)")
                }
            } else {
                print("Pas de photoURL pour \(uid)")
            }

            return (nomUtilisateur, photo)
        } catch {
            print("Unable to retrieve this user info: \(uid)")
        }
        
        return (nil, nil)
    }
}
