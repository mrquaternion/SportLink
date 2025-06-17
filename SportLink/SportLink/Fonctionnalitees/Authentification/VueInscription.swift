//
//  VueInscription.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-06-17.
//

import SwiftUI

struct VueInscription: View {
    @Environment(\.dismiss) var dismiss

    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false

    var body: some View {
        VStack {
            // Vagues
            ZStack(alignment: .topLeading) {
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

                // 🔙 Flèche retour
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 30))
                            .padding()
                    }
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.leading, 16)
                .foregroundColor(.black)
                .navigationBarBackButtonHidden(true)
            }
            
            Spacer().frame(height: 60)
            
            // Titre
            Text("Create Your Account")
                .font(.system(size: 28, weight: .bold))

            Spacer().frame(height: 30)

            // Formulaire
            VStack(spacing: 30) {
                // Username avec icône info
                champAvecIconeInfo(
                    texte: $username,
                    placeholder: "Username *",
                    showEye: false
                )

                // Email sans icône info
                champSimple(
                    texte: $email,
                    placeholder: "Email *"
                )

                // Password avec œil et icône info
                champAvecIconeInfoEtEye(
                    texte: $password,
                    placeholder: "Password *",
                    show: $showPassword
                )

                // Confirm password avec œil
                champAvecEye(
                    texte: $confirmPassword,
                    placeholder: "Confirm Password",
                    show: $showConfirmPassword
                )
            }
            .padding(.horizontal)

            Spacer().frame(height: 70)

            // Bouton SIGN UP
            Button(action: {
                // Action de création de compte
            }) {
                Text("SIGN UP")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(30)
                    .padding(.horizontal, 50)
            }

            Spacer()
        }
        .ignoresSafeArea(edges: .top)
    }

    
    
    
    
    
    
    // MARK: - Composantes internes
    
    func champSimple(texte: Binding<String>, placeholder: String) -> some View {
        TextField(placeholder, text: texte)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.6)))
    }

    func champAvecEye(texte: Binding<String>, placeholder: String, show: Binding<Bool>) -> some View {
        HStack {
            if show.wrappedValue {
                TextField(placeholder, text: texte)
            } else {
                SecureField(placeholder, text: texte)
            }
            Button {
                show.wrappedValue.toggle()
            } label: {
                Image(systemName: show.wrappedValue ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.6)))
    }

    func champAvecIconeInfo(texte: Binding<String>, placeholder: String, showEye: Bool) -> some View {
        HStack {
            Image(systemName: "info.circle")
                .foregroundColor(.black)
            TextField(placeholder, text: texte)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.6)))
    }

    func champAvecIconeInfoEtEye(texte: Binding<String>, placeholder: String, show: Binding<Bool>) -> some View {
        HStack {
            Image(systemName: "info.circle")
                .foregroundColor(.black)
            if show.wrappedValue {
                TextField(placeholder, text: texte)
            } else {
                SecureField(placeholder, text: texte)
            }
            Button {
                show.wrappedValue.toggle()
            } label: {
                Image(systemName: show.wrappedValue ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.6)))
    }
}








#Preview {
    VueInscription()
}
