//
//  VueConnexion.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-06-16.
//

import SwiftUI

struct VueConnexion: View {
    @State private var email = ""
    @State private var motDePasse = ""
    @State private var motDePasseVisible = false

    var body: some View {
        NavigationStack {
            VStack {
                // Vagues
                ZStack(alignment: .top) {
                    Vague(cstMaxX: 0.8, cstMaxY: 1.4)
                        .fill(Color("CouleurRougeClaire"))
                        .frame(height: 235)
                    
                    Vague(cstMaxX: 0.8, cstMaxY: 1.35)
                        .fill(Color("CouleurRougeMedium"))
                        .frame(height: 205)
                        .shadow(color: .black.opacity(0.6), radius: 10, y: -6)
                    
                    Vague()
                        .fill(Color("CouleurParDefaut"))
                        .frame(height: 170)
                        .shadow(color: .black.opacity(0.8), radius: 10, y: -4)
                }
                
                Spacer().frame(height: 60)

                // Titre
                Text("Welcome to SportLink!")
                    .font(.title)
                    .bold()
                    .padding(.top, 16)

                Text("Discover new sports")
                    .foregroundColor(.gray)
                    .padding(.bottom, 32)

                Spacer().frame(height: 30)

                // Champ email
                TextField("Username or email", text: $email)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.6)))
                    .padding(.horizontal)

                // Champ mot de passe
                HStack {
                    if motDePasseVisible {
                        TextField("Password", text: $motDePasse)
                    } else {
                        SecureField("Password", text: $motDePasse)
                    }
                    Button(action: {
                        motDePasseVisible.toggle()
                    }) {
                        Image(systemName: motDePasseVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.6)))
                .padding(.horizontal)

                Spacer().frame(height: 30)

                // Bouton LOGIN
                Button(action: {
                    // Action de connexion
                }) {
                    Text("LOGIN")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(30)
                        .padding(.horizontal, 50)
                }
                .padding(.top)

                // Lien mot de passe oublié
                Button(action: {
                    // Action
                }) {
                    Text("Forgot password ?")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
                .padding(.top, 8)

                Spacer()

                // Lien vers inscription
                HStack {
                    Text("Don't have an account?")
                    NavigationLink(destination: VueInscription()) {
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
    VueConnexion()
}

