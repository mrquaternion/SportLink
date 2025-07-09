//
//  VueExplorer.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-15.
//

import SwiftUI

struct ExplorerVue: View {
    @EnvironmentObject var emplacementsVM: DonneesEmplacementService
    
    @State private var modeAffichage: ModeAffichage = .liste
    
    @Binding var utilisateur: Utilisateur

    var body: some View {
        ZStack {
            VStack {
                if modeAffichage == .liste {
                    ExplorerListeVue(utilisateur: $utilisateur)
                } else {
                    ExplorerCarteVue(utilisateur: $utilisateur)
                        .environmentObject(emplacementsVM)
                }
            }
            
            VStack {
                Spacer()
                
                BoutonSwitchExplorer(modeAffichage: $modeAffichage)
                    .padding(.bottom, 20)
            }
        }
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
