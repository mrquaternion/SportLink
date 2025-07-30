//
//  GoingVue.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-08.
//

import SwiftUI

struct ActivitesInscritesVue: View {
    @EnvironmentObject var activitesVM: ActivitesVM
    @StateObject private var activitesInscritesVM: ActivitesInscritesVM
    @State private var activiteAffichantInfo: Activite.ID? = nil
    @State private var activiteSelectionnee: Activite? = nil
    
    init(serviceEmplacements: DonneesEmplacementService) {
        self._activitesInscritesVM = StateObject(wrappedValue: ActivitesInscritesVM(
            serviceActivites: ServiceActivites(),
            serviceEmplacements: serviceEmplacements
        ))
    }
    
    var body: some View {
        ScrollView { sectionActivites }
            .task {
                if activitesInscritesVM.activites.isEmpty {
                    print("we are refetching")
                    await activitesInscritesVM.fetchActivitesInscrites()
                }
            }
            .refreshable { await activitesInscritesVM.fetchActivitesInscrites() }
            .onTapGesture {
                if activiteAffichantInfo != nil {
                    withAnimation { activiteAffichantInfo = nil }
                }
            }
            .navigationDestination(for: Activite.self) { activite in
                if let binding = activitesInscritesVM.bindingActivite(id: activite.id!) {
                    DetailsActivite(activite: binding)
                        .environmentObject(activitesVM)
                        .environmentObject(activitesInscritesVM)
                        .cacherBoutonEditable()
                        .cacherBoutonJoin()
                }
            }
    }
    
    var sectionActivites: some View {
        LazyVStack(spacing: 20) {
            ForEach(activitesInscritesVM.activites) { activite in
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
    ActivitesInscritesVue(serviceEmplacements: DonneesEmplacementService())
        .environmentObject(DonneesEmplacementService())
        .environmentObject(ActivitesVM(serviceEmplacements: DonneesEmplacementService()))
        .environmentObject(ActivitesInscritesVM(serviceActivites: ServiceActivites(), serviceEmplacements: DonneesEmplacementService()))
}
