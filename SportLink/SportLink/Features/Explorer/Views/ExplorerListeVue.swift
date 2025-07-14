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
    @State private var afficherFiltreOverlay = false
    @State private var estSelectionnee = false
    @State private var activiteAffichantInfo: Activite.ID? = nil
    
    init(utilisateur: Binding<Utilisateur>, emplacementsVM: DonneesEmplacementService) {
        self._utilisateur = utilisateur
        self._vm = StateObject(wrappedValue: ExplorerListeVM(service: emplacementsVM))
    }
    
    var body: some View {
        ZStack {
            if vm.activitesTriees.isEmpty {
                VStack(alignment: .center, spacing: 12) {
                    Image(systemName: "figure.run")
                        .font(.system(size: 60))
                    Text("No activity has been organized \n for the selected settings")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                }
                .foregroundColor(.gray)
            }
            
            ScrollView {
                sectionFiltreEtTri
                
                if afficherFiltreOverlay {
                    boiteFiltrage
                        .padding(.bottom, 10)
                        .padding(.horizontal, 20)
                        .transition(.scale(scale: 1, anchor: .top).combined(with: .opacity))
                }
                
                sectionActivites
            }
            .animation(.easeInOut, value: afficherFiltreOverlay)
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
    }
    
    private var boiteFiltrage: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sports")
                .font(.headline)
            Divider()
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Sport.allCases, id: \.self) { sport in
                    HStack {
                        Button {
                            if vm.sportsChoisis.contains(sport.nom) {
                                vm.sportsChoisis.remove(sport.nom)
                            } else {
                                vm.sportsChoisis.insert(sport.nom)
                            }
                        } label: {
                            HStack {
                                Image(systemName: sport.icone)
                                Text(sport.nom.capitalized)
                                
                                Spacer()
                                
                                Image(systemName: vm.sportsChoisis.contains(sport.nom) ? "checkmark.square.fill" : "square")
                            }
                            .foregroundColor(.black)
                        }
                    }
                    
                    Divider()
                }
            }
            .frame(maxWidth: .infinity)
            
            DatePicker(
                "Date",
                selection: Binding(
                    get: { vm.dateAFiltree },
                    set: { nvValeur in
                        vm.dateAFiltree = nvValeur
                    }
                ),
                in: vm.dateMin...vm.dateMax,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .font(.headline)
            .padding(.top, 20)
        }
        .padding()
        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var sectionFiltreEtTri: some View {
        HStack(spacing: 8) {
            BarreDeRecherche(texteDeRecherche: $vm.texteDeRecherche)
            
            BoutonFiltrage(afficherFiltreOverlay: $afficherFiltreOverlay, dateAFiltree: $vm.dateAFiltree)
            
            BoutonTriage(optionTri: $vm.optionTri)
        }
        .padding([.leading, .trailing, .top], 20)
        .padding(.bottom, afficherFiltreOverlay ? 10 : 20)
    }
    
    @ViewBuilder
    private var sectionActivites: some View {
        if !vm.activites.isEmpty {
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
            .padding(.horizontal, 20)
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
    
    ExplorerListeVue(
        utilisateur: .constant(mockUtilisateur),
        emplacementsVM: DonneesEmplacementService()
    )

}
