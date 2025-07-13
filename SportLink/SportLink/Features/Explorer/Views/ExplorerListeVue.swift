//
//  ExplorerListeVue.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-20.
//

import SwiftUI

struct ExplorerListeVue: View {
    @Binding var utilisateur: Utilisateur
    @StateObject var serviceActivites = ServiceActivites()
    @StateObject var gestionnaire = GestionnaireLocalisation()
    @StateObject var vm: ExplorerListeVM
    @State private var estSelectionnee = false
    @State private var activiteAffichantInfo: Activite.ID? = nil
    
    init(utilisateur: Binding<Utilisateur>, emplacementsVM: DonneesEmplacementService) {
        self._utilisateur = utilisateur
        self._vm = StateObject(wrappedValue: ExplorerListeVM(service: emplacementsVM))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                sectionFiltreEtTri
                    .padding(.bottom, 10)
                
                sectionActivites
            }
        }
        .onAppear {
            Task {
                await serviceActivites.fetchTousActivites()
                vm.activites = serviceActivites.activites
            }
        }
        .onTapGesture {
            // Dès qu'on tape dans la vue, on ferme toute info
            if activiteAffichantInfo != nil {
                withAnimation { activiteAffichantInfo = nil }
            }
        }
    }
    
    private var sectionFiltreEtTri: some View {
        HStack(spacing: 8) {
            BarreDeRecherche(texteDeRecherche: $vm.texteDeRecherche)
            
            Menu {
                Button { vm.optionTri = .date } label: {
                    let estSelectionne = vm.optionTri == .date ? "✓" : ""
                    Text(estSelectionne + " Date ascending")
                }
                Button { vm.optionTri = .dateInv } label: {
                    let estSelectionne = vm.optionTri == .dateInv ? "✓" : ""
                    Text(estSelectionne + " Date descending")
                }
                Button { vm.optionTri = .distance } label: {
                    let estSelectionne = vm.optionTri == .distance ? "✓" : ""
                    Text(estSelectionne + " Distance ascending")
                }
                Button { vm.optionTri = .distanceInv } label: {
                    let estSelectionne = vm.optionTri == .distanceInv ? "✓" : ""
                    Text(estSelectionne + " Distance descending")
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down")
                    .font(.title3)
                    .foregroundStyle(.black)
                    .padding(12)
                    .background(Color(.systemGray5))
                    .clipShape(Circle())
            }
            .shadow(
                color: .black.opacity(0.15),
                radius: 10, x: 0, y: 0
            )
            .padding(.trailing)
        }
    }
    
    private var sectionActivites: some View {
        VStack(spacing: 20) {
            ForEach(vm.activitesTriees, id: \.id) { activite in
                RangeeActivite(
                    afficherInfo: Binding(
                        get: { activiteAffichantInfo == activite.id },
                        set: { newValue in
                            activiteAffichantInfo = newValue ? activite.id : nil
                        }
                    ),
                    estSelectionnee: $estSelectionnee,
                    activite: activite,
                    geolocalisation: gestionnaire.location?.coordinate
                )
                .environmentObject(vm)
            }
        }
        .padding(.horizontal, 22)
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
    
    ExplorerListeVue(
        utilisateur: .constant(mockUtilisateur),
        emplacementsVM: DonneesEmplacementService()
    )

}
