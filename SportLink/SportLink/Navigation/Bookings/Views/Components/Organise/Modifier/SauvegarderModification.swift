//
//  SauvegarderModification.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-17.
//

import SwiftUI
import FirebaseFirestore

@MainActor
func sauvegarderTitre(
    titre: String,
    activite: Activite,
    vm: ActivitesOrganiseesVM,
    onSuccess: @escaping () -> Void
) {
    vm.serviceActivites.recupererIdActiviteParInfraId(activite.infraId) { idRecupere, erreur in
        guard erreur == nil, let id = idRecupere else { return }

        vm.serviceActivites.modifierTitreActivite(idActivite: id, nouveauTitre: titre) { error in
            guard error == nil else { return }
            vm.mettreAJourTitreLocalement(idActivite: id, nouveauTitre: titre)
            onSuccess()
        }
    }
}

@MainActor
func sauvegarderDate(
    activite: Activite,
    vm: ActivitesOrganiseesVM,
    onSuccess: @escaping () -> Void
) {
    vm.serviceActivites.recupererIdActiviteParInfraId(activite.infraId) { idRecupere, erreur in
        guard erreur == nil, let id = idRecupere else { return }

        let db = Firestore.firestore()
        db.collection("activites").document(id).updateData([
            "date.debut": Timestamp(date: activite.date.debut),
            "date.fin": Timestamp(date: activite.date.fin)
        ]) { error in
            guard error == nil else {
                print("Erreur lors de la mise à jour : \(error!)")
                return
            }
            onSuccess()
        }
    }
}

@MainActor
func sauvegarderParticipants(
    activite: Activite,
    vm: ActivitesOrganiseesVM,
    onSuccess: @escaping () -> Void
) {
    vm.serviceActivites.recupererIdActiviteParInfraId(activite.infraId) { idRecupere, erreur in
        guard erreur == nil, let id = idRecupere else { return }

        let db = Firestore.firestore()
        db.collection("activites").document(id).updateData([
            "nbJoueursRecherches": activite.nbJoueursRecherches
        ]) { error in
            guard error == nil else {
                print("Erreur lors de la mise à jour du nombre de participants : \(error!)")
                return
            }

            // ➕ Mettre à jour localement aussi
            vm.mettreAJourNbJoueursRecherchesLocalement(idActivite: id, nb: activite.nbJoueursRecherches)
            onSuccess()
        }
    }
}

@MainActor
func sauvegarderAutorisationInvitations(
    activite: Activite,
    vm: ActivitesOrganiseesVM,
    onSuccess: @escaping () -> Void
) {
    vm.serviceActivites.recupererIdActiviteParInfraId(activite.infraId) { idRecupere, erreur in
        guard erreur == nil, let id = idRecupere else { return }

        let db = Firestore.firestore()
        db.collection("activites").document(id).updateData([
            "invitationsOuvertes": activite.invitationsOuvertes
        ]) { error in
            guard error == nil else {
                print("Erreur lors de la mise à jour des invitations ouvertes : \(error!)")
                return
            }
            onSuccess()
        }
    }
}

@MainActor
func sauvegarderDescription(
    activite: Activite,
    vm: ActivitesOrganiseesVM,
    onSuccess: @escaping () -> Void
) {
    vm.serviceActivites.recupererIdActiviteParInfraId(activite.infraId) { idRecupere, erreur in
        guard erreur == nil, let id = idRecupere else { return }

        let db = Firestore.firestore()
        db.collection("activites").document(id).updateData([
            "description": activite.description
        ]) { error in
            guard error == nil else {
                print("Erreur lors de la mise à jour de la description : \(error!)")
                return
            }
            // Mise à jour locale
            vm.mettreAJourDescriptionLocalement(idActivite: id, nouvelleDescription: activite.description)

            onSuccess()
        }
    }
}
