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
    @State private var afficherSeeMore = false
    @State private var titreActiviteSelectionnee: String = ""
    @State private var sportActiviteSelectionne: Sport = .soccer
    @State private var debutActivite: Date = Date()
    @State private var finActivite: Date = Date()

    var listeActivites: some View {
        ForEach(serviceActivites.activites) { activite in
            if let infra = emplacementsVM.infrastructures.first(where: { $0.id == activite.infraId }),
               let parc = emplacementsVM.parcs.first(where: { $0.index == infra.indexParc }) {
                ActiviteBoite(
                    activite: activite,
                    parc: parc,
                    infra: infra,
                    onSeeMore: {
                        titreActiviteSelectionnee = activite.titre
                        sportActiviteSelectionne = Sport.depuisNom(activite.sport)
                        afficherSeeMore = true
                        debutActivite = activite.date.debut
                        finActivite = activite.date.fin
                        
                    }
                )
            }
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    listeActivites
                }
                .padding()
            }
            .onAppear {
                emplacementsVM.chargerDonnees()
                Task {
                    await serviceActivites.fetchActivitesParOrganisateur(organisateurId: "mockID")
                }
            }
        }
        
        .fullScreenCover(isPresented: $afficherSeeMore) {
            SeeMoreVueHosted(
                titre: titreActiviteSelectionnee,
                sport: sportActiviteSelectionne,
                debut: debutActivite,
                fin: finActivite
            )
        }
    }
}

#Preview {
    NavigationStack {
        HostedVue()
            .environmentObject(DonneesEmplacementService())
    }
}
