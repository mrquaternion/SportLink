//
//  ChoixSportVue.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-24.
//

import SwiftUI

struct ChoixSportVue: View {
    @State private var sportsChoisis: Set<String> = []
    @ObservedObject var authVM: AuthentificationVM
    @State private var allerDisponibilites = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Choose Your Favorite Sports")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, 30)
                        .padding(.horizontal)

                    VStack(spacing: 16) {
                        ForEach(Sport.allCases, id: \.self) { sport in
                            Button {
                                if sportsChoisis.contains(sport.nom) {
                                    sportsChoisis.remove(sport.nom)
                                } else {
                                    sportsChoisis.insert(sport.nom)
                                }
                            } label: {
                                HStack {
                                    Image(systemName: sport.icone)
                                        .foregroundColor(.red)

                                    Text(sport.nom.capitalized)
                                        .foregroundColor(.black)

                                    Spacer()

                                    Image(systemName: sportsChoisis.contains(sport.nom) ? "checkmark.square.fill" : "square")
                                        .foregroundColor(.red)
                                }
                                .padding(.horizontal)
                            }

                            Divider()
                        }
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 60) // espace pour éviter le recouvrement
                }
            }

            // Navigation vers disponibilité (invisible)
            NavigationLink(
                destination: ChoixDisponibilitesVue(
                    authVM: authVM,
                    sportsChoisis: Array(sportsChoisis)
                ),
                isActive: $allerDisponibilites
            ) {
                EmptyView()
            }

            // Bouton statique
            VStack(spacing: 0) {
                Divider()
                Button(action: {
                    allerDisponibilites = true
                }) {
                    Text("CONTINUE")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(30)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 10)
                }
            }
            .background(.ultraThinMaterial)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview("ChoixSportVue") {
    ChoixSportVue(authVM: AuthentificationVM())
}
