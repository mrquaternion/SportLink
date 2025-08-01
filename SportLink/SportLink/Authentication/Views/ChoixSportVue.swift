//
//  ChoixSportVue.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-24.
//

import SwiftUI

enum EtapeSupplementaireInscription: Hashable {
    case choixDisponibilites
    case photoProfil
    case geolocalisation
}

struct ChoixSportVue: View {
    @ObservedObject var vm: InscriptionVM
    let onComplete: () -> Void
    @State private var etape: [EtapeSupplementaireInscription] = []

    @State private var lignesDeSports: [[Sport]] = []

    var body: some View {
        NavigationStack(path: $etape) {
            ScrollView {
                VStack(spacing: 32) {
                    enTete
                    grilleDeTags
                }
                .padding(.horizontal)
            }
            .safeAreaInset(edge: .bottom) {
                boutonContinuer
            }
            .navigationBarBackButtonHidden(true)
            .onAppear { recalculerLignes() }
            .onChange(of: UIScreen.main.bounds.width) { _, _ in recalculerLignes() }
            .navigationDestination(for: EtapeSupplementaireInscription.self) { etape in
                switch etape {
                case .choixDisponibilites:
                    ChoixDisponibilitesVue(vm: vm, etape: $etape)
                case .photoProfil:
                    AjoutPhotoProfilVue(vm: vm, etape: $etape)
                case .geolocalisation:
                    ModalitesEtGeolocalisationVue(vm: vm, etape: $etape, onComplete: onComplete)
                }
            }
        }
    }

    private var enTete: some View {
        VStack {
            HStack {
                Color.clear
                .frame(height: 30)
                .padding()
            }
            HStack {
                Text("select your favourites sports".localizedCapitalized)
                    .font(.title.weight(.bold))
                Spacer()
            }
        }
    }

    private var grilleDeTags: some View {
        LazyVStack(alignment: .leading, spacing: 12) {
            ForEach(lignesDeSports, id: \.self) { ligne in
                HStack(spacing: 10) {
                    ForEach(ligne, id: \.self) { sport in
                        TagSportVue(vm: vm, sport: sport)
                    }
                }
            }
        }
    }

    private var boutonContinuer: some View {
        Button {
            guard !vm.sportsFavoris.isEmpty else { return }
            etape.append(.choixDisponibilites)
        } label: {
            Text("Continuer")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(vm.sportsFavoris.isEmpty ? Color.gray : Color.red)
                .foregroundColor(.white)
                .cornerRadius(25)
                .padding(EdgeInsets(top: 8, leading: 50, bottom: 12, trailing: 50))
        }
    }

    // MARK: - Calcul dynamique des lignes de tags
    private func recalculerLignes() {
        let tousLesSports = Sport.allCases
        let largeurDisponible = UIScreen.main.bounds.width - 48
        let espacement: CGFloat = 8
        let largeurIcone: CGFloat = 24
        let margeInterne: CGFloat = 24

        var nouvellesLignes: [[Sport]] = [[]]
        var largeurCourante: CGFloat = 0

        let police = UIFont.systemFont(ofSize: 17)
        for sport in tousLesSports {
            let label = sport.nomPourAffichage.capitalized
            let largeurTexte = (label as NSString).size(withAttributes: [.font: police]).width
            let largeurCapsule = largeurTexte + largeurIcone + margeInterne

            if largeurCourante + largeurCapsule + espacement > largeurDisponible {
                nouvellesLignes.append([sport])
                largeurCourante = largeurCapsule + espacement
            } else {
                nouvellesLignes[nouvellesLignes.count - 1].append(sport)
                largeurCourante += largeurCapsule + espacement
            }
        }
   
        lignesDeSports = nouvellesLignes
    }
}

extension Array {
    mutating func deplacer(de source: Int, vers destination: Int) {
        guard source != destination,
              indices.contains(source),
              indices.contains(destination) else { return }
        
        let element = remove(at: source)
        insert(element, at: destination)
    }
    
    mutating func deplacer(_ element: Element, versIndex nouvelIndex: Int) where Element: Equatable {
        guard let indexActuel = firstIndex(of: element),
              indices.contains(nouvelIndex) else { return }
        
        deplacer(de: indexActuel, vers: nouvelIndex)
    }
}

// Vue représentant un tag pour un sport individuel
struct TagSportVue: View {
    @ObservedObject var vm: InscriptionVM
    let sport: Sport

    private var estSelectionne: Bool { vm.sportsFavoris.contains(sport.rawValue) }

    var body: some View {
        Label {
            Text(sport.nomPourAffichage.capitalized)
        } icon: {
            Image(systemName: sport.icone)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(estSelectionne ? Color.red : Color.gray.opacity(0.3))
        )
        .foregroundColor(estSelectionne ? Color.white : Color.primary)
        .scaleEffect(estSelectionne ? 0.95 : 1.0)
        .animation(.spring(), value: vm.sportsFavoris)
        .onTapGesture { basculerSelection() }
    }

    // Bascule la sélection du sport
    private func basculerSelection() {
        if estSelectionne {
            vm.sportsFavoris.removeAll { $0 == sport.rawValue }
        } else {
            vm.sportsFavoris.append(sport.rawValue)
        }
    }
}

#Preview {
    ChoixSportVue(vm: InscriptionVM(), onComplete: {})
}
