//
//  ServiceActivite.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-02.
//

import Foundation

import FirebaseCore
import FirebaseFirestore

@MainActor
class ServiceActivites: ObservableObject {
    @Published var activites: [Activite] = []
    
    func fetchActivitesParInfrastructureEtDateAsync(infraId: String, date: Date) async {
        do {
            let requeteSnapshot = try await Firestore.firestore()
                .collection("activites")
                .whereField("infraId", isEqualTo: infraId)
                .getDocuments()

            let dtos = try requeteSnapshot.documents.map { document in
                try document.data(as: ActiviteDTO.self)
            }

            let activitesConverties = try dtos.map { try $0.versActivite() }
            
            // Filtrer par date
            let calendrier = Calendar.current
            let activitesFiltrees = activitesConverties
                .filter { calendrier.isDate($0.date.debut, inSameDayAs: date) }
                .sorted { $0.date.debut < $1.date.debut }
            
            // Assigner un ID localement
            let activites = activitesFiltrees.map { activite in
                var activiteMutable = activite
                activiteMutable.id = UUID().uuidString
                return activiteMutable
            }

            self.activites = activites
        } catch {
            print("Erreur lors de la récupération des activités : \(error)")
        }
    }
    
    func sauvegarderActiviteAsync(activite: Activite) async {
        let dto = activite.versDTO()
        do {
            let ref = try Firestore.firestore()
                .collection("activites")
                .addDocument(from: dto)
            print("Activité sauvegardée avec l’ID :", ref.documentID)
        } catch {
            print("Erreur lors de la sauvegarde de l’activité :", error)
        }
    }
}
