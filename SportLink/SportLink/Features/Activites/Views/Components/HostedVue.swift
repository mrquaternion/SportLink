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
    @State private var infraActiviteSelectionnee: Infrastructure?

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
                        debutActivite = activite.date.debut
                        finActivite = activite.date.fin
                        infraActiviteSelectionnee = emplacementsVM.infraPour(id: activite.infraId)
                        
                        /* let infraTrouvee = emplacementsVM.infraPour(id: activite.infraId)
                        print("🧭 ID recherché : \(activite.infraId)")
                        print("🏗️ Infrastructure trouvée : \(String(describing: infraTrouvee))")
                        
                        infraActiviteSelectionnee = infraTrouvee */
                        
                        // ➤ Attendre un "tick" d'UI avant d'afficher le fullScreen
                        DispatchQueue.main.async {
                            afficherSeeMore = true
                        }
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
        
        .fullScreenCover(item: $infraActiviteSelectionnee) { infra in
            SeeMoreVueHosted(
                titre: titreActiviteSelectionnee,
                sport: sportActiviteSelectionne,
                debut: debutActivite,
                fin: finActivite,
                infrastructure: infra
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
