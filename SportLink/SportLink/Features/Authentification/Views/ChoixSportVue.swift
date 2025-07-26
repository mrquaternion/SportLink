//
//  ChoixSportVue.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-24.
//

import SwiftUI

struct ChoixSportVue: View {
    @ObservedObject var authVM: AuthentificationVM
    @State private var allerDisponibilites = false

    @State private var selectedSports: Set<String> = []
    @State private var sportRows: [[String]] = []

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Choose Your Favorite Sports")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, 30)
                        .padding(.horizontal)

                    GeometryReader { geometry in
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(sportRows, id: \.self) { row in
                                HStack(spacing: 10) {
                                    ForEach(row, id: \.self) { sport in
                                        Label {
                                            Text(sport.capitalized)
                                        } icon: {
                                            Image(systemName: Sport.depuisNom(sport).icone)
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(
                                            Capsule()
                                                .fill(selectedSports.contains(sport) ? .red : .gray.opacity(0.3))
                                        )
                                        .foregroundColor(selectedSports.contains(sport) ? .white : .black)
                                            .onTapGesture {
                                                toggleSelection(for: sport)
                                            }
                                            .fixedSize()
                                            .scaleEffect(selectedSports.contains(sport) ? 0.95 : 1.0)
                                            .animation(.spring(), value: selectedSports)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .onAppear {
                            calculateRows(for: geometry.size.width)
                        }
                    }
                    .frame(minHeight: 150) // taille minimale pour éviter un layout cassé

                    Spacer(minLength: 60)
                }
            }

            // Navigation
            NavigationLink(
                destination: ChoixDisponibilitesVue(
                    authVM: authVM,
                    sportsChoisis: Array(selectedSports)
                ),
                isActive: $allerDisponibilites
            ) {
                EmptyView()
            }

            // Bouton Continue fixe
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

    // MARK: - Sélection
    private func toggleSelection(for sport: String) {
        if selectedSports.contains(sport) {
            selectedSports.remove(sport)
        } else {
            selectedSports.insert(sport)
        }
    }

    // MARK: - Découpage en lignes dynamiques
    private func calculateRows(for availableWidth: CGFloat) {
        let allSports = Sport.allCases.map { $0.nom }
        var rows: [[String]] = [[]]
        var currentRowWidth: CGFloat = 0
        let spacing: CGFloat = 10
        let horizontalPadding: CGFloat = 24 // total de padding + marges

        for sport in allSports {
            let label = sport.capitalized
            let font = UIFont.systemFont(ofSize: 17)
            let size = (label as NSString).size(withAttributes: [.font: font])
            let iconeLargeurEstimee: CGFloat = 24 // espace pour l'icône SF Symbol + espace entre icône et texte
            let capsuleWidth = size.width + iconeLargeurEstimee + 24 // padding horizontal + icône
            if currentRowWidth + capsuleWidth + spacing > availableWidth - horizontalPadding {
                rows.append([sport])
                currentRowWidth = capsuleWidth + spacing
            } else {
                rows[rows.count - 1].append(sport)
                currentRowWidth += capsuleWidth + spacing
            }
        }

        self.sportRows = rows
    }
}

#Preview {
    ChoixSportVue(authVM: AuthentificationVM())
}
