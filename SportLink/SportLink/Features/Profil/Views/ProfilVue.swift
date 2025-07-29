//
//  ProfilVue.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-06-27.
//

import SwiftUI

struct ProfilVue: View {
    let onDeconnexion: () -> Void

    @EnvironmentObject var utilisateurVM: UtilisateurConnecteVM
    @State private var montrerImagePicker = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Your Profile")
                .font(.largeTitle.bold())
                .padding(.top, 40)

            Button(action: {
                montrerImagePicker = true
            }) {
                if let image = utilisateurVM.photoUIImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 130, height: 130)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        .shadow(radius: 5)
                } else {
                    ZStack {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 130, height: 130)
                        Image(systemName: "camera.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                    }
                }
            }
            .sheet(isPresented: $montrerImagePicker) {
                // Tu peux ajouter l'ImagePicker ici plus tard si tu veux modifier la photo
            }

            Text(utilisateurVM.utilisateur?.nomUtilisateur ?? "Utilisateur")
                .font(.title2)

            // Affichage des sports favoris
            if let sports = utilisateurVM.utilisateur?.sportsFavoris, !sports.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("My Favorite Sports")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)

                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(grouperSports(sports), id: \.self) { ligne in
                            HStack(spacing: 10) {
                                ForEach(ligne, id: \.self) { sport in
                                    TagSportStatiqueVue(sport: sport)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }

            Button {
                Task {
                    do {
                        try GestionnaireAuthentification.partage.deconnexion()
                        onDeconnexion()
                    } catch {
                        print("Erreur déconnexion: \(error.localizedDescription)")
                    }
                }
            } label: {
                Text("Log out")
                    .foregroundColor(.red)
                    .bold()
            }
            .padding(.top, 20)

            Spacer()
        }
        .padding()
        .task {
            await utilisateurVM.chargerInfosUtilisateur()
        }
    }
}

// MARK: - Capsule sport statique

struct TagSportStatiqueVue: View {
    let sport: Sport

    var body: some View {
        Label {
            Text(sport.nom.capitalized)
        } icon: {
            Image(systemName: sport.icone)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color.red)
        )
        .foregroundColor(.white)
    }
}

// MARK: - Regroupe les sports par ligne de 3

func grouperSports(_ sports: [Sport], maxParLigne: Int = 3) -> [[Sport]] {
    var lignes: [[Sport]] = []
    var ligneActuelle: [Sport] = []

    for sport in sports {
        ligneActuelle.append(sport)
        if ligneActuelle.count == maxParLigne {
            lignes.append(ligneActuelle)
            ligneActuelle = []
        }
    }

    if !ligneActuelle.isEmpty {
        lignes.append(ligneActuelle)
    }

    return lignes
}

/*
#Preview {
    ProfilVue(onDeconnexion: { print("Non déconnecté") })
        .environmentObject(UtilisateurConnecteVM())
}
*/
