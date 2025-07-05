//
//  ExplorerListeVue.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-20.
//

import SwiftUI

struct ExplorerListeVue: View {
    @State private var activites: [Activite] = []
    @Binding var utilisateur: Utilisateur
    
    var body: some View {
        sectionActivites
    }
    
    private var sectionActivites: some View {
        EmptyView()
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
