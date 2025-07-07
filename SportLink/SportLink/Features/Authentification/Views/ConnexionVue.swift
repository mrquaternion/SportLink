//
//  VueConnexion.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-06-16.
//

import SwiftUI

struct ConnexionVue: View {
    
    @StateObject var authVM = AuthentificationVM()

    @State private var motDePasseVisible = false

    var body: some View {
        NavigationStack {
            VStack {
                VaguesVue()
                
                Spacer()

                // Titre
                Text("Welcome to SportLink!")
                    .font(.title)
                    .bold()
                    .padding(.top, 16)

                Text("Discover new sports")
                    .foregroundColor(.gray)
                    .padding(.bottom, 32)

                Spacer()

                
                VStack(spacing: 30) {
                    authVM.champSimple(
                        texte: $authVM.courriel,
                        placeholder: "Email "
                    )
                    
                    authVM.champAvecEye(
                        texte: $authVM.motDePasse,
                        placeholder: "Password ",
                        show: $motDePasseVisible
                    )
                }
                .padding(.horizontal, 30)
                
                Spacer()

                // Bouton LOGIN
                Button(action: {
                    // Action de connexion
                }) {
                    Text("LOGIN")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(30)
                        .padding(.horizontal, 50)
                }
                .padding(.top)

                // Bouton mot de passe oublié
                Button(action: {
                    // Action
                }) {
                    Text("Forgot password?")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
                .padding(.top, 8)

                Spacer()

                // Bouton inscription
                HStack {
                    Text("Don't have an account?")
                    NavigationLink(destination: InscriptionVue()) {
                        Text("Register")
                            .foregroundColor(.red)
                            .bold()
                    }
                }
                .font(.footnote)
                .padding(.bottom, 20)
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}

#Preview {
    ConnexionVue()
}

