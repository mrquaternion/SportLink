//
//  VueExplorer.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-15.
//

import SwiftUI

struct ExplorerVue: View {
    let serviceEmplacements: DonneesEmplacementService
    @EnvironmentObject var activitesVM: ActivitesVM
    @StateObject private var listeVM: ExplorerListeVM
    @State private var modeAffichage: ModeAffichage = .liste
    @Binding var utilisateur: Utilisateur

    init(utilisateur: Binding<Utilisateur>, serviceEmplacements: DonneesEmplacementService) {
        self._utilisateur = utilisateur
        self.serviceEmplacements = serviceEmplacements
        self._listeVM = StateObject(wrappedValue: ExplorerListeVM(
            serviceEmplacements: serviceEmplacements,
            serviceActivites: ServiceActivites()
        ))
    }

    var body: some View {
        ZStack {
            Group {
                if modeAffichage == .liste {
                    ExplorerListeVue(utilisateur: $utilisateur)
                        .environmentObject(serviceEmplacements)
                        .environmentObject(activitesVM)
                        .environmentObject(listeVM)
                        .transition(.move(edge: .leading))
                } else {
                    ExplorerCarteVue(utilisateur: $utilisateur)
                        .environmentObject(serviceEmplacements)
                        .transition(.move(edge: .trailing))
                }
            }
            
            VStack {
                Spacer()
                BoutonSwitchExplorer(modeAffichage: $modeAffichage)
                    .padding(.bottom, 70)
            }
        }
        .ignoresSafeArea(.keyboard)
        .animation(.easeInOut, value: modeAffichage)
    }
}

#Preview {
    let mockUtilisateur = Utilisateur(
        nomUtilisateur: "mathias13",
        courriel: "",
        photoProfil: "",
        disponibilites: [:],
        sportsFavoris: [],
        activitesFavoris: [],
        partenairesRecents: []
    )
    
    ExplorerVue(utilisateur: .constant(mockUtilisateur), serviceEmplacements: DonneesEmplacementService())
        .environmentObject(ActivitesVM(serviceEmplacements: DonneesEmplacementService()))
        .environmentObject(AppVM())
}
