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
                VStack(spacing: 16) {
                    Text("Select a marker")
                        .font(.headline)
                        .padding(.top, 40)

                    Divider()

                    // Carte
                    CarteSelectionInfrastructure(sportChoisis: $sportChoisis, infraChoisie: $infraChoisie)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .padding(.horizontal)

                    Spacer()

                    Button {
                        montrerCarte = false
                    } label: {
                        Text("Close")
                            .padding(.horizontal, 20)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color("CouleurParDefaut"))
                        
                }
                .background(.ultraThinMaterial)
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(20)
        }
    }
}

#Preview {
    BoutonAvecApercuCarte(sportChoisis: .constant(["All"]), infraChoisie: .constant(nil))
        .environmentObject(DonneesEmplacementService())
}
