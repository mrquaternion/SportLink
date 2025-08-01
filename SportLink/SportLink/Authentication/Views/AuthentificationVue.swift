//
//  VueConnexion.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-06-16.
//

import SwiftUI
import FirebaseAuth

enum RouteInscription: Hashable {
    case inscription
}

struct AuthentificationVue: View {
    @StateObject var connexionVM = ConnexionVM()
    @StateObject var inscriptionVM = InscriptionVM()
    @State private var motDePasseVisible = false
    @State private var chemin: [RouteInscription] = []
    @State private var montrerChoixSport = false
    
    let onEtatChange: (EtatAuthentification) -> Void

    var body: some View {
        NavigationStack(path: $chemin) {
            VStack {
                VaguesVue()
                Spacer()
                messageBienvenue
                Spacer()
                formulaire
                    .padding(.horizontal, 30)
                
                Spacer()

                boutonConnexion

                boutonOublieMotDePasse

                Spacer()

                // Bouton inscription
                HStack {
                    Text("don't have an account?".localizedFirstCapitalized)
                        .font(.subheadline)
                    Button {
                        chemin.append(.inscription)
                        connexionVM.resetChampsApresChangementDeVue()
                    } label: {
                        Text("register".localizedCapitalized)
                            .font(.subheadline.weight(.bold))
                            .foregroundColor(.red)
                    }
                }
                .font(.footnote)
                .padding(.bottom, 20)
            }
            .ignoresSafeArea(.keyboard)
            .edgesIgnoringSafeArea(.top)
            .navigationDestination(for: RouteInscription.self) { route in
                switch route {
                case .inscription:
                    InscriptionVue(vm: inscriptionVM, onInscriptionComplete: {
                        // When inscription is complete, dismiss the inscription view and show ChoixSportVue
                        chemin.removeAll()
                        montrerChoixSport = true
                    })
                }
            }
            .fullScreenCover(isPresented: $montrerChoixSport) {
                ChoixSportVue(vm: inscriptionVM, onComplete: {
                    montrerChoixSport = false
                    onEtatChange(.authentifie) // ICI on rentre dans l'appli directement
                })
            }
        }
    }
    
    @ViewBuilder
    private var messageBienvenue: some View {
        // Titre
        Text("welcome to SportLink!".localizedFirstCapitalized)
            .font(.title)
            .bold()
            .padding(.top, 16)
        // Sous-titre
        Text("discover new sports".localizedFirstCapitalized)
            .foregroundColor(.gray)
            .padding(.bottom, 32)
    }
    
    @ViewBuilder
    private var formulaire: some View {
        VStack(spacing: 22) {
            VStack(alignment: .leading, spacing: 4) {
                ChampSimple(texte: $connexionVM.courriel, placeholder: "email".localizedCapitalized, erreur: $connexionVM.courrielErreur)
                    .autocorrectionDisabled(true)
                Text(connexionVM.courrielErreur ?? " ").foregroundStyle(.red).font(.caption)
            }
  
            VStack(alignment: .leading, spacing: 4) {
                ChampAvecEye(texte: $connexionVM.motDePasse, placeholder: "password".localizedCapitalized, estVisible: $motDePasseVisible, erreur: $connexionVM.motDePasseErreur)
                    .autocorrectionDisabled(true)
                Text(connexionVM.motDePasseErreur ?? " ").foregroundStyle(.red).font(.caption)
            }
        }
    }
    
    @ViewBuilder
    private var boutonConnexion: some View {
        Button {
            Task {
                let nouvelEtat = await connexionVM.connexionFirebase()
                if nouvelEtat != .nonAuthentifie {
                    onEtatChange(nouvelEtat)
                }
            }
        } label: {
            Text("sign in".localizedCapitalized)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .cornerRadius(30)
                .padding(.horizontal, 50)
        }
        .padding(.top)
    }
    
    @ViewBuilder
    private var boutonOublieMotDePasse: some View {
        Button {
            // Action
        } label: {
            Text("forgot password?".localizedFirstCapitalized)
                .font(.subheadline)
        }
        .padding(.top, 8)
    }
}

extension GestionnaireAuthentification {
    func connecterUtilisateur(courriel: String, motDePasse: String) async throws -> AuthDonneesResultatModele {
        let authResultatDonnees = try await Auth.auth().signIn(withEmail: courriel, password: motDePasse)
        return AuthDonneesResultatModele(utilisateur: authResultatDonnees.user)
    }
    
    func verifierEtatAuthentification() async -> EtatAuthentification {
        do {
            let _ = try obtenirUtilisateurAuthentifier()
            return .authentifie
        } catch {
            return .nonAuthentifie
        }
    }
}

#Preview {
    AuthentificationVue(onEtatChange: { etat in print("État changé vers: \(etat)") })
}
