//
//  SauvegardeTitreFonction.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-17.
//

import SwiftUI

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
