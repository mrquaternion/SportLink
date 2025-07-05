//
//  SwiftUIView.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-04.
//

import SwiftUI
import MapKit

struct CarteCreationActivite: View {
    @EnvironmentObject var emplacementsVM: DonneesEmplacementService
    
    @State var location: CLLocation? = {
        if let coord = UserDefaults.standard.dernierePosition {
            return CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        }
        return nil
    }()
    @State private var centrageInitial = true
    @State private var demandeRecentrage = false
    @State private var parcSelectionne: Parc?
    @State private var infraSelectionnee: Infrastructure?
    @State private var aInteragiAvecCarte = false
    @State private var deselectionnerAnnotation = false
    @State private var typeDeCarteSelectionne: TypeDeCarte = .standard
    
    @Binding var sportChoisis: Set<String>
    @Binding var infraChoisie: Infrastructure?
    
    var body: some View {
        CarteVue(
            parcs: emplacementsVM.parcs,
            infras: emplacementsVM.infrastructures,
            localisationUtilisateur: location,
            centrageInitial: $centrageInitial,
            demandeRecentrage: $demandeRecentrage,
            parcSelectionne: $parcSelectionne,
            infraSelectionnee: $infraSelectionnee,
            aInteragiAvecCarte: $aInteragiAvecCarte,
            deselectionnerAnnotation: $deselectionnerAnnotation,
            typeDeCarteSelectionne: $typeDeCarteSelectionne,
            filtresSelectionnes: $sportChoisis
        )
        .ignoresSafeArea(.all)
        .onChange(of: infraSelectionnee?.id) {
            infraChoisie = infraSelectionnee
        }
        .onAppear {
            // Synchroniser l'infrastructure sélectionnée au démarrage
            infraSelectionnee = infraChoisie
        }
    }
}

#Preview {
    CarteCreationActivite(
        sportChoisis: .constant(["All"]),
        infraChoisie: .constant(nil)
    )
    .environmentObject(DonneesEmplacementService())
}
