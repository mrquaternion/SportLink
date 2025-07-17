//
//  HostedVue.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-09.
//

import SwiftUI

struct ActivitesOrganiseesVue: View {
    @EnvironmentObject var tabBarEtat: TabBarEtat
    
    @StateObject private var vm: ActivitesOrganiseesVM
    
    @State private var activiteAffichantInfo: Activite.ID? = nil
    @State private var activiteSelectionnee: Activite? = nil
    
    @Binding var cacherOnglets: Bool
    
    init(serviceEmplacements: DonneesEmplacementService, cacherOnglets: Binding<Bool>) {
        self._vm = StateObject(wrappedValue: ActivitesOrganiseesVM(
            serviceActivites: ServiceActivites(),
            serviceEmplacements: serviceEmplacements
        ))
        self._cacherOnglets = cacherOnglets
    }

    var body: some View {
        NavigationStack {
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
                        .onAppear {
                            tabBarEtat.estVisible = false
                            cacherOnglets = true
                        }
                        .onDisappear {
                            tabBarEtat.estVisible = true
                            cacherOnglets = false
                        }
                }
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
    ActivitesOrganiseesVue(
        serviceEmplacements: DonneesEmplacementService(),
        cacherOnglets: .constant(false)
    )
    .environmentObject(DonneesEmplacementService())
    .environmentObject(ActivitesVM(serviceEmplacements: DonneesEmplacementService()))
}
