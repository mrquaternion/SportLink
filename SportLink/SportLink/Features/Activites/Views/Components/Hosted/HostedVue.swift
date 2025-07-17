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
    @State private var nomParcSelectionne: String = ""
    @State private var placesDisponibles: Int = 0
    @State private var activiteSelectionnee: Activite? = nil

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
                        nomParcSelectionne = parc.nom ?? ""
                        placesDisponibles = activite.nbJoueursRecherches
                        activiteSelectionnee = activite
                        
                        infraActiviteSelectionnee = emplacementsVM.infraPour(id: activite.infraId)
                    
                        
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
        
        .fullScreenCover(item: $activiteSelectionnee) { activite in
            if let infra = emplacementsVM.infraPour(id: activite.infraId),
               let parc = emplacementsVM.parcs.first(where: { $0.index == infra.indexParc }) {

                SeeMoreVueHosted(
                    titre: activite.titre,
                    sport: Sport.depuisNom(activite.sport),
                    debut: activite.date.debut,
                    fin: activite.date.fin,
                    nomParc: parc.nom ?? "",
                    infrastructure: infra,
                    nbPlacesDisponibles: activite.nbJoueursRecherches,
                    invitationsOuvertes: activite.invitationsOuvertes
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        HostedVue()
            .environmentObject(DonneesEmplacementService())
    }
}
