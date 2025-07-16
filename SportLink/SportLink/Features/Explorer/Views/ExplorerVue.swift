//
//  VueExplorer.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-15.
//

import SwiftUI

struct ExplorerVue: View {
    @EnvironmentObject var serviceEmplacements: DonneesEmplacementService
    @State private var modeAffichage: ModeAffichage = .liste
    @State private var cacherBoutonSwitch = false
    @Binding var utilisateur: Utilisateur

    var body: some View {
        ZStack {
            VStack {
                if modeAffichage == .liste {
                    ExplorerListeVue(
                        utilisateur: $utilisateur,
                        cacherBoutonSwitch: $cacherBoutonSwitch,
                        serviceEmplacements: serviceEmplacements
                    )
                    .environmentObject(serviceEmplacements)
                } else {
                    ExplorerCarteVue(utilisateur: $utilisateur)
                        .environmentObject(serviceEmplacements)
                }
            }
            
            VStack {
                Spacer()
                BoutonSwitchExplorer(modeAffichage: $modeAffichage)
                    .padding(.bottom, 70)
                    .opacity(cacherBoutonSwitch ? 0.0 : 1.0)
                    .allowsHitTesting(!cacherBoutonSwitch)
                    .animation(.easeInOut(duration: 0.2), value: cacherBoutonSwitch)
                
            }
        }
        .ignoresSafeArea(.keyboard)
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
    
    ExplorerVue(utilisateur: .constant(mockUtilisateur))
        .environmentObject(DonneesEmplacementService())
}
