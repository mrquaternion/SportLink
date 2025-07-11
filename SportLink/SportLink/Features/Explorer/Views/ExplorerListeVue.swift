//
//  ExplorerListeVue.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-20.
//

import SwiftUI

struct ExplorerListeVue: View {
    @EnvironmentObject var emplacementsVM: DonneesEmplacementService
    @Binding var utilisateur: Utilisateur
    @StateObject var serviceActivites = ServiceActivites()
    @StateObject var gestionnaire = GestionnaireLocalisation()
    @State private var estSelectionnee = false
    
    var body: some View {
        ScrollView {
            VStack {
                sectionActivites
            }
            
        }
        .onAppear {
            Task {
                await serviceActivites.fetchTousActivites()
            }
        }
    }
    
    private var sectionActivites: some View {
        VStack(spacing: 12) {
            ForEach(serviceActivites.activites, id: \.id) { activite in
                RangeeActivite(
                    estSelectionnee: $estSelectionnee,
                    activite: activite,
                    geolocalisation: gestionnaire.location?.coordinate
                )
                .environmentObject(emplacementsVM)
            }
        }
        .padding(.horizontal)
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
    
    ExplorerListeVue(utilisateur: .constant(mockUtilisateur))
}
