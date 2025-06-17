//
//  VueInscription.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-06-17.
//

import SwiftUI

struct InscriptionVue: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var authVM = AuthVueModele()

    @State private var motDePasseVisible = false
    @State private var motDePasseConfirmeVisible = false

    var body: some View {
        VStack {
            // Vagues et bouton retour
            ZStack(alignment: .topLeading) {
                VaguesVue()

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
            
            Spacer()
            
            Text("Create Your Account")
                .font(.system(size: 28, weight: .bold))

            Spacer()

            // Formulaire
            VStack(spacing: 30) {
                authVM.champAvecIconeInfo(
                    texte: $authVM.nomUtilisateur,
                    placeholder: "Username *",
                    showEye: false
                )

                authVM.champSimple(
                    texte: $authVM.courriel,
                    placeholder: "Email *"
                )

                authVM.champAvecIconeInfoEtEye(
                    texte: $authVM.motDePasse,
                    placeholder: "Password *",
                    show: $motDePasseVisible
                )

                authVM.champAvecEye(
                    texte: $authVM.motDePasseConfirme,
                    placeholder: "Confirm Password",
                    show: $motDePasseConfirmeVisible
                )
            }
            .padding(.horizontal, 30)

            Spacer()

            // Bouton SIGN UP
            Button(action: {
                // Action de création de compte
            }) {
                Text("SIGN UP")
                    .font(.system(size: 24, weight: .bold))
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
}


#Preview {
    InscriptionVue()
}
