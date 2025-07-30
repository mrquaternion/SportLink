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
        VStack(spacing: 0) {
            
            Text("Your Profile")
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.top, 16)
                .padding(.bottom, 12)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.05))
            
            ScrollView {
                VStack(spacing: 20) {

                    ZStack(alignment: .bottomTrailing) {
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

                        Image(systemName: "pencil.circle.fill")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundColor(.blue)
                            .background(Color.white.clipShape(Circle()))
                            .offset(x: -4, y: -4)
                    }
                    .frame(width: 130, height: 130)
                    
                    Text(utilisateurVM.utilisateur?.nomUtilisateur ?? "Utilisateur")
                        .font(.title2)
                    
                    // MARK: - Disponibilités
                    if let disponibilites = utilisateurVM.utilisateur?.disponibilites {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Weekly Availabilities")
                                    .font(.headline)
                                Spacer()
                                Button(action: {}) {
                                    Text("Modify")
                                        .foregroundColor(.blue)
                                        .font(.subheadline)
                                }
                            }
                            .padding(.top)
                            
                            ForEach(JourDeLaSemaine.allCases) { jour in
                                let creneaux = disponibilites[jour.numeroDansLaSemaine] ?? []
                                
                                if !creneaux.isEmpty {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(jour.rawValue.capitalized(with: .current))
                                            .font(.subheadline)
                                            .bold()
                                        
                                        ForEach(creneaux, id: \.self) { range in
                                            HStack {
                                                Image(systemName: "clock")
                                                    .foregroundColor(.red)
                                                Text(range)
                                                    .font(.body)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    }
                    Divider()
                        .background(Color.gray.opacity(0.4))
                        .padding(.horizontal)
                    
                    // MARK: - Sports favoris
                    if let sportsFavoris = utilisateurVM.utilisateur?.sportsFavoris {
                        let tousLesSports = Sport.allCases
                        let sportsNonFavoris = tousLesSports.filter { sport in
                            !sportsFavoris.contains(where: { $0.nom == sport.nom })
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("My Favorite Sports")
                                .font(.headline)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(sportsFavoris, id: \.self) { sport in
                                        TagSportStatiqueVue(sport: sport)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            
                            if !sportsNonFavoris.isEmpty {
                                Text("Other Sports")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        ForEach(sportsNonFavoris, id: \.self) { sport in
                                            TagSportGriseVue(sport: sport)
                                        }
                                    }
                                    .padding(.vertical, 4)
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
                    .padding(.bottom, 20)
                    
                    Spacer()
                }
                .padding()
            }
            .task {
                await utilisateurVM.chargerInfosUtilisateur()
            }
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

struct TagSportGriseVue: View {
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
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        )
        .foregroundColor(.gray)
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

extension JourDeLaSemaine {
    var numeroDansLaSemaine: Int {
        switch self {
        case .lundi: return 1
        case .mardi: return 2
        case .mercredi: return 3
        case .jeudi: return 4
        case .vendredi: return 5
        case .samedi: return 6
        case .dimanche: return 7
        }
    }
}

/*
#Preview {
    ProfilVue(onDeconnexion: { print("Non déconnecté") })
        .environmentObject(UtilisateurConnecteVM())
}
*/
