//
//  HostedVue.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-09.
//

import SwiftUI

struct HostedVue: View {
    @StateObject private var hostedVM = HostedActivitesVM()
    @EnvironmentObject var emplacementsVM: DonneesEmplacementService

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if hostedVM.hostedActivites.isEmpty {
                    Text("No activities found.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(hostedVM.hostedActivites) { activite in
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
            }
            .padding()
        }
        .onAppear {
            emplacementsVM.chargerDonnees()
            Task {
                await hostedVM.chargerHostedActivitesPour(organisateurId: "mockID")
            }
        }
    }
}

#Preview {
    HostedVue()
        .environmentObject(DonneesEmplacementService())
}

