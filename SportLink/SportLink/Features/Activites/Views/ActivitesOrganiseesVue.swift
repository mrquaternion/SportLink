//
//  ActivitesOrganiseesVue.swift
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
                if let binding = vm.bindingActivite(id: activite.id!) {
                    DetailsActivite(activite: binding)
                        .environmentObject(activitesVM)
                        .environmentObject(vm)
                        .cacherBoutonEditable(false)
                        .cacherBoutonJoin()
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
                .dateEtendue()
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 70) // faire de la place par rapport a le tabbar
        .padding(.top, 20) // faire de la place par rapport a l'onglet
    }
}

#Preview {
    ActivitesOrganiseesVue(serviceEmplacements: DonneesEmplacementService())
        .environmentObject(DonneesEmplacementService())
        .environmentObject(ActivitesVM(serviceEmplacements: DonneesEmplacementService()))
}
