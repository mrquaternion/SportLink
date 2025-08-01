//
//  GestionnaireAuthentification.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

struct AuthDonneesResultatModele {
    let uid: String
    let courriel: String?
    let photoUrl: String?
    
    init(utilisateur: User) {
        self.uid = utilisateur.uid
        self.courriel = utilisateur.email
        self.photoUrl = utilisateur.photoURL?.absoluteString
    }
}

@MainActor
class Session: ObservableObject {
    @Published var avatar: Image = Image(systemName: "person.crop.circle.fill")
    @Published var activitesRecommandees: [Activite] = []
    @Published var estPret: Bool = false
    
    init() {
        Task {
            if let avatarUIImage = try? await GestionnaireAuthentification.partage.telechargerPhoto() {
                await MainActor.run {
                    self.avatar = Image(uiImage: avatarUIImage)
                }
            }
            await fetchActivitesRecommandes()
            estPret = true
        }
    }
    
    func fetchActivitesRecommandes() async {
        do {
            let requeteSnapshot = try await Firestore.firestore()
                .collection("activites")
                .getDocuments()
            
            let dtos = try requeteSnapshot.documents.map { document in
                try document.data(as: ActiviteDTO.self)
            }

            let activitesConverties = dtos.map { $0.versActivite() }
            
            // Assigner un ID localement
            let activites = activitesConverties.map { activite in
                var activiteMutable = activite
                activiteMutable.id = UUID().uuidString
                return activiteMutable
            }
            
            self.activitesRecommandees = Array(activites.prefix(3))
        } catch {
            print("Erreur lors de la récupération des activités : \(error)")
        }
    }
}

@MainActor
final class GestionnaireAuthentification {
    static let partage = GestionnaireAuthentification()
    private init() { }
    
    func creerUtilisateur(courriel: String, motDePasse: String) async throws -> AuthDonneesResultatModele {
        let authResultatDonnees = try await Auth.auth().createUser(withEmail: courriel, password: motDePasse)
        return AuthDonneesResultatModele(utilisateur: authResultatDonnees.user)
    }
    
    func obtenirUtilisateurAuthentifier() throws -> AuthDonneesResultatModele {
        guard let utilisateur = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDonneesResultatModele(utilisateur: utilisateur)
    }
    
    func enregistrerProfil(
        nomUtilisateur: String,
        sports: [String],
        disponibilites: [String: [(Date, Date)]],
        photo: UIImage?
    ) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "Utilisateur", code: 1, userInfo: [NSLocalizedDescriptionKey: "Utilisateur non connecté"])
        }
        
        var photoUrl: String? = nil
        if let image = photo {
            photoUrl = try await chargerPhoto(image: image, pour: uid)
        }
        
        let formateurDate = DateFormatter()
        formateurDate.dateFormat = "HH:mm"
        
        let disposFormatees = disponibilites.mapValues { plages in
            plages.map { plage in
                "\(formateurDate.string(from: plage.0))-\(formateurDate.string(from: plage.1))"
            }
        }
        
        let donnees: [String: Any] = [
            "nomUtilisateur": nomUtilisateur,
            "sportsFavoris": sports,
            "disponibilites": disposFormatees,
            "photoUrl": photoUrl ?? ""
        ]
        
        try await Firestore.firestore().collection("utilisateurs").document(uid).setData(donnees)
    }
    
    private func chargerPhoto(image: UIImage, pour uid: String) async throws -> String {
        let refStockage = Storage.storage().reference().child("utilisateurs/\(uid)/photo.jpg")
        guard let donnee = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "Compression", code: 0, userInfo: [NSLocalizedDescriptionKey: "Erreur compression image."])
        }
        
        let _ = try await refStockage.putDataAsync(donnee)
        return try await refStockage.downloadURL().absoluteString
    }
    
    func telechargerPhoto() async throws -> UIImage? {
        let utilisateur = try obtenirUtilisateurAuthentifier()
        let refDocument = Firestore.firestore().collection("utilisateurs").document(utilisateur.uid)

        let snapshot = try await refDocument.getDocument()
        guard let donnees = snapshot.data(),
              let urlString = donnees["photoUrl"] as? String,
              let url = URL(string: urlString)
        else {
            print("Aucune URL trouvée, ou URL invalide")
            return nil
        }

        let (donneesImage, _) = try await URLSession.shared.data(from: url)
        return UIImage(data: donneesImage)
    }
    
    func deconnexion() throws {
        try Auth.auth().signOut()
    }
}
