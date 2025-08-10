//
//  MiniCarteBouton.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-04.
//

import SwiftUI
import MapKit


struct BoutonAvecApercuCarte: View {
    private let vm: CreerActiviteVM
    
    @State private var montrerCarte = false
    @Binding var sportChoisis: Set<String>
    @Binding var infraChoisie: Infrastructure?
    
    init(
        vm: CreerActiviteVM,
        sportChoisis: Binding<Set<String>>,
        infraChoisie: Binding<Infrastructure?>
    ) {
        self.vm = vm
        self._sportChoisis = sportChoisis
        self._infraChoisie = infraChoisie
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ApercuCarte(vm: vm)
           
            if infraChoisie != nil {
                Text("\(vm.obtenirDistanceDeUtilisateur(pour: infraChoisie)) away")
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8) // padding INTERNE
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .background(.ultraThinMaterial)
                    )
                    .padding([.trailing, .top], 10) // padding EXTERNE
            }
        }
        .onTapGesture { montrerCarte = true }
        .sheet(isPresented: $montrerCarte) {
            NavigationView {
                VStack(alignment: .leading, spacing: 14) {
                    (
                        Text("Please select an infrastructure marker. ".localizedFirstCapitalized) +
                        Text("you can leave once the marker animation is done.".localizedFirstCapitalized)
                    )
                    .font(.subheadline.weight(.light))
                    .padding([.top, .horizontal])
                    VStack(spacing: 0) {
                        Divider()
                        // Carte
                        CarteSelectionInfrastructure(
                            sportChoisis: $sportChoisis,
                            infraChoisie: $infraChoisie
                        )
                    }
                }
                .navigationTitle("Select a marker")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            montrerCarte = false
                        }
                        .fontWeight(.medium)
                        .foregroundStyle(Color.red)
                    }
                }
                .toolbarBackground(Color(.systemBackground), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                
            }
            .presentationDetents([.large])
            .presentationCornerRadius(24)
            .interactiveDismissDisabled(true)
        }
       
    }
}

#Preview {
    BoutonAvecApercuCarte(
        vm: CreerActiviteVM(serviceActivites: ServiceActivites(), serviceEmplacements: DonneesEmplacementService()),
        sportChoisis: .constant(["All"]),
        infraChoisie: .constant(nil)
    )
    .environmentObject({
        let s = DonneesEmplacementService()
        s.chargerDonnees()
        return s
    }())
}

