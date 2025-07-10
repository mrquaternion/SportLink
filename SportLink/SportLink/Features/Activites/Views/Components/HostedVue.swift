//
//  HostedVue.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-09.
//

import SwiftUI

struct HostedVue: View {
    @StateObject var serviceActivites = ServiceActivites()
    @EnvironmentObject var emplacementsVM: DonneesEmplacementService

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(serviceActivites.activites) { activite in
                    if let infra = emplacementsVM.infrastructures.first(where: { $0.id == activite.infraId }),
                       let parc = emplacementsVM.parcs.first(where: { $0.index == infra.indexParc }) {
                        ActiviteBoite(
                            titre: activite.titre,
                            sport: Sport.depuisNom(activite.sport),
                            infraNom: parc.nom ?? "Nom inconnu", // ✅ On passe le nom du parc
                            date: activite.date.interval,
                            nbPlacesRestantes: activite.nbJoueursRecherches,
                            imageApercu: nil
                        )
                    }
                }
            }
            .padding()
        }
        .onAppear {
            Task {
                await serviceActivites.fetchActivitesParOrganisateur(organisateurId: "mockID")
            }
        }
    }
}

#Preview {
    HostedVue()
        .environmentObject(DonneesEmplacementService())
}

