//
//  ActiviteBoite.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-09.
//


import SwiftUI
import MapKit

struct ActiviteBoite: View {
    let activite: Activite
    let parc: Parc
    let infra: Infrastructure
    let onSeeMore: () -> Void

    let couleur = Color(red: 0.784, green: 0.231, blue: 0.216)
    @State private var afficherInfo = false

    var nbPlacesRestantes: String {
        let diff = activite.nbJoueursRecherches - activite.participants.count
        return diff == 0 ? "No spot left" : "\(diff) spots left"
    }

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 12) {
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

                            VStack(alignment: .leading, spacing: 8) {
                                Text(parc.nom ?? "Nom inconnu")
                                    .lineLimit(1)
                                    .font(.callout)
                                    .fontWeight(.light)
                                    .foregroundStyle(Color(.systemGray))

                                Text("\(dateEnString)")
                                    .font(.subheadline)
                                    .foregroundStyle(.black)
                                
                                Text("\(heureDebut) - \(heureFin)")
                                    .font(.subheadline)
                                    .foregroundStyle(.black)
                            }
                        }

                        Spacer()
                    }
                }
            }
            .padding([.top, .trailing, .leading])

            VStack(spacing: 0) {
                Divider()
                Button(action: onSeeMore) {
                    Text("See more")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.red)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
        )
        .contentShape(Rectangle())
    }

    // MARK: - Propriétés formatées locales (je veux pas toucher à PlageHoraire)

    private var dateEnString: String {
        let calendar = Calendar.current

        if calendar.isDateInToday(activite.date.debut) {
            return "Today"
        } else {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter.string(from: activite.date.debut)
        }
    }

    private var heureDebut: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeStyle = .short
        return formatter.string(from: activite.date.debut)
    }

    private var heureFin: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeStyle = .short
        return formatter.string(from: activite.date.fin)
    }
}
