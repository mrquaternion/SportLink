//
//  HostedVue.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-09.
//

import SwiftUI

struct ActivitesOrganiseesVue: View {
    @EnvironmentObject var activitesVM: ActivitesVM
    
    @StateObject private var vm: ActivitesOrganiseesVM
    
    @State private var activiteAffichantInfo: Activite.ID? = nil
    @State private var activiteSelectionnee: Activite? = nil
    
    init(serviceEmplacements: DonneesEmplacementService) {
        self._vm = StateObject(wrappedValue: ActivitesOrganiseesVM(
            serviceActivites: ServiceActivites(),
            serviceEmplacements: serviceEmplacements
        ))
    }

    var body: some View {
        ScrollView { sectionActivites }
            .task { await vm.chargerActivitesParOrganisateur(organisateurId: "mockID") }
            .refreshable { await vm.chargerActivitesParOrganisateur(organisateurId: "mockID") }
            .onTapGesture {
                if activiteAffichantInfo != nil {
                    withAnimation { activiteAffichantInfo = nil }
                }
            }
            .navigationDestination(for: Activite.self) { activite in
                DetailsActivite(activite: activite)
                    .environmentObject(activitesVM) // navigationDestination brise la chaine des environemments donc on doit le redonner
            }
    }
    
    var sectionActivites: some View {
        LazyVStack(spacing: 20) {
            ForEach(vm.activites) { activite in
                RangeeActivite(
                    afficherInfo: Binding(
                        get: { activiteAffichantInfo == activite.id },
                        set: { newValue in
                            activiteAffichantInfo = newValue ? activite.id : nil
                        }
                    ),
                    activite: activite
                )
                .cacherBoutonJoin()
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 70) // faire de la place par rapport a le navbar
        .padding(.top, 100) // faire de la place par rapport a l'onglet
    }
}

#Preview {
    ActivitesOrganiseesVue(serviceEmplacements: DonneesEmplacementService())
        .environmentObject(DonneesEmplacementService())
        .environmentObject(ActivitesVM(serviceEmplacements: DonneesEmplacementService()))
}
