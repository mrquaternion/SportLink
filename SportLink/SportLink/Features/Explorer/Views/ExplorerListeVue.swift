//
//  ExplorerListeVue.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-20.
//

import SwiftUI

struct ExplorerListeVue: View {
    @StateObject private var vm: ExplorerListeVM
    
    @Binding var utilisateur: Utilisateur
    @Binding var cacherBoutonSwitch: Bool
    @State private var afficherFiltreOverlay = false
    @State private var activiteAffichantInfo: Activite.ID? = nil
    
    init(
        utilisateur: Binding<Utilisateur>,
        cacherBoutonSwitch: Binding<Bool>,
        serviceEmplacements: DonneesEmplacementService
    ) {
        self._utilisateur = utilisateur
        self._cacherBoutonSwitch = cacherBoutonSwitch
        self._vm = StateObject(wrappedValue: ExplorerListeVM(
            serviceEmplacements: serviceEmplacements,
            serviceActivites: ServiceActivites()
        ))
    }
    
    var body: some View {
        NavigationStack {
            sectionFiltreEtTri
            
            if afficherFiltreOverlay {
                boiteFiltrage
                    .padding(.horizontal, 20)
                    .transition(.scale(scale: 1, anchor: .top).combined(with: .opacity))
            }
            
            VStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(dateAAffichee(vm.dateAFiltree))
                        .font(.title2)
                        .foregroundStyle(Color(.gray))
                    Divider()
                }
                .padding(.horizontal, 20)
                .contentShape(Rectangle())

                ScrollView { sectionActivites }
                    .animation(.easeInOut, value: afficherFiltreOverlay)
                    .task { await vm.chargerActivites() }
                    .refreshable { await vm.chargerActivites() }
                    .navigationDestination(for: Activite.self) { activite in
                        DetailsActivite(activite: activite)
                            .onAppear { cacherBoutonSwitch = true }
                            .onDisappear { cacherBoutonSwitch = false }
                    }
            }
            .onTapGesture {
                if activiteAffichantInfo != nil {
                    withAnimation { activiteAffichantInfo = nil }
                }
                
                if afficherFiltreOverlay { afficherFiltreOverlay = false }
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
                            if vm.sportsChoisis.contains(sport.nom) { vm.sportsChoisis.remove(sport.nom) }
                            else { vm.sportsChoisis.insert(sport.nom) }
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
                selection: $vm.dateAFiltree,
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
    
    private var sectionActivites: some View {
        Group {
            if vm.estEnChargement {
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.5)
                            .progressViewStyle(CircularProgressViewStyle())
                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
                .frame(minHeight: 550)
            } else if !vm.activitesTriees.isEmpty {
                LazyVStack(spacing: 20) {
                    ForEach(vm.activitesTriees, id: \.id) { activite in
                        RangeeActivite(
                            afficherInfo: Binding(
                                get: { activiteAffichantInfo == activite.id },
                                set: { newValue in
                                    activiteAffichantInfo = newValue ? activite.id : nil
                                }
                            ),
                            activite: activite
                        )
                        .environmentObject(vm)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 90) // faire de la place par rapport a le switcher
            } else {
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        MessageAucuneActivite()
                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
                .frame(minHeight: 550)
            }
        }
    }
    
    private func dateAAffichee(_ date: Date) -> String {
        let calendrier = Calendar.current
        
        let jourDeSemaineFormat = DateFormatter()
        jourDeSemaineFormat.locale = Locale.current
        jourDeSemaineFormat.dateFormat = "EEEE"
        
        let jourDuMoisFormat = DateFormatter()
        jourDuMoisFormat.locale = Locale.current
        jourDuMoisFormat.dateFormat = "MMMM d"
 
        let jourDeSemaine: String
        if calendrier.isDateInToday(date) {
            jourDeSemaine = "Today"
        } else if calendrier.isDateInTomorrow(date) {
            jourDeSemaine = "Tomorrow"
        } else {
            jourDeSemaine = jourDeSemaineFormat.string(from: date)
        }
        
        let jourDuMois = jourDuMoisFormat.string(from: date)
        return "\(jourDeSemaine), \(jourDuMois)"
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
        cacherBoutonSwitch: .constant(false),
        serviceEmplacements: DonneesEmplacementService()
    )
}
