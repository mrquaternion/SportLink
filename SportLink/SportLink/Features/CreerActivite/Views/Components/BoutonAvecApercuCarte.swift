//
//  MiniCarteBouton.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-04.
//

import SwiftUI
import MapKit

struct BoutonAvecApercuCarte: View {
    @EnvironmentObject var emplacementsVM: DonneesEmplacementService
    @State private var montrerCarte = false
    @Binding var sportChoisis: Set<String>
    @Binding var infraChoisie: Infrastructure?

    var body: some View {
        Button {
            montrerCarte = true
        } label: {
            ApercuCarte(infraChoisie: infraChoisie)
        }
        .sheet(isPresented: $montrerCarte) {
            NavigationView {
                // Carte
                VStack {
                    CarteSelectionInfrastructure(
                        sportChoisis: $sportChoisis,
                        infraChoisie: $infraChoisie
                    )
                }
                .navigationTitle("Select a marker")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            montrerCarte = false
                        }
                        .fontWeight(.medium)
                        .foregroundStyle(Color("CouleurParDefaut"))
                    }
                }
                .toolbarBackground(Color(.systemBackground), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            }
            .presentationDetents([.large])
            .presentationCornerRadius(30)
        }
    }
}

#Preview {
    BoutonAvecApercuCarte(sportChoisis: .constant(["All"]), infraChoisie: .constant(nil))
        .environmentObject(DonneesEmplacementService())
}

