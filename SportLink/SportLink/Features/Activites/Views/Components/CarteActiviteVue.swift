//
//  CarteActiviteVue.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-15.
//

import SwiftUI
import MapKit

struct CarteActiviteVue: View {
    let activite: Activite
    let parc: Parc
    let infra: Infrastructure
    var estFavoriInitial: Bool = false

    let couleur = Color(red: 0.784, green: 0.231, blue: 0.216)
    @State private var estFavoris: Bool
    @State private var afficherInfo = false

    init(activite: Activite, parc: Parc, infra: Infrastructure, estFavoriInitial: Bool = false) {
        self.activite = activite
        self.parc = parc
        self.infra = infra
        self._estFavoris = State(initialValue: estFavoriInitial)
    }

    var nbPlacesRestantes: String {
        let diff = activite.nbJoueursRecherches - activite.participants.count
        return diff == 0 ? "No spot left" : "\(diff) spots left"
    }

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 12) {
                ZStack(alignment: .bottomTrailing) {
                    ZStack(alignment: .topTrailing) {
                        ZStack {
                            Sport.depuisNom(activite.sport).arriereplan
                                .resizable()
                                .scaledToFill()
                                .frame(height: 140)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .blur(radius: afficherInfo ? 6 : 0)
                                .contentShape(RoundedRectangle(cornerRadius: 12))
                                .onTapGesture {
                                    withAnimation {
                                        afficherInfo.toggle()
                                    }
                                }

                            if afficherInfo {
                                Text("Image for illustration only, not actual representation of the \(activite.sport) infrastructure.")
                                    .multilineTextAlignment(.center)
                                    .font(.footnote)
                                    .foregroundColor(.black)
                                    .padding(.horizontal)
                                    .padding(.vertical, 10)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(6)
                                    .padding(.horizontal, 14)
                                    .transition(.opacity.combined(with: .scale))
                            }
                        }

                        Image(systemName: "mappin.and.ellipse")
                            .font(.caption)
                            .foregroundStyle(.white)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(couleur.opacity(0.9))
                            )
                            .padding([.trailing, .top], 10)
                            .blur(radius: afficherInfo ? 6 : 0)
                            .zIndex(1)
                    }

                    Image(systemName: estFavoris ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 19))
                        .foregroundStyle(estFavoris ? couleur : .white)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                        .padding([.bottom, .trailing], 8)
                        .onTapGesture {
                            withAnimation(.linear(duration: 0.2)) {
                                estFavoris.toggle()
                            }
                        }
                        .disabled(afficherInfo)
                        .blur(radius: afficherInfo ? 6 : 0)
                }

                VStack(alignment: .trailing, spacing: 0) {
                    HStack(spacing: 6) {
                        Circle()
                            .frame(width: 7, height: 7)
                        Text(nbPlacesRestantes)
                            .font(.system(size: 16))
                            .fontWeight(.light)
                    }
                    .foregroundStyle(Color(uiColor: activite.statut.couleur))

                    HStack(alignment: .top) {
                        Image(systemName: Sport.depuisNom(activite.sport).icone)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28)
                            .padding(.trailing, 4)
                            .padding(.top, 10)

                        VStack(alignment: .leading) {
                            Text(activite.titre)
                                .font(.title3)
                                .fontWeight(.semibold)

                            VStack(alignment: .leading, spacing: 12) {
                                Text(parc.nom ?? "Nom inconnu")
                                    .lineLimit(1)
                                    .font(.callout)
                                    .fontWeight(.light)
                                    .foregroundStyle(Color(.systemGray))

                                Text(activite.date.affichage)
                                    .fontWeight(.medium)
                            }
                        }

                        Spacer()
                    }
                }
            }
            .padding([.top, .trailing, .leading])

            VStack(spacing: 0) {
                Divider()

                HStack(spacing: 0) {
                    Button {
                        // Action voir plus
                    } label: {
                        Text("See more")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.primary)
                    }

                    Divider().frame(width: 1, height: 50)

                    Button {
                        // Action joindre partie
                    } label: {
                        Text("Join Game")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(couleur)
                            .fontWeight(.semibold)
                    }
                }
                .frame(height: 50)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
        )
        .contentShape(Rectangle())
    }
}
