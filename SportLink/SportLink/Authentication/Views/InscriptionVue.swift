//
//  VueInscription.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-06-17.
//

import SwiftUI

struct InscriptionVue: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: InscriptionVM
    let onInscriptionComplete: () -> Void
    
    @State private var motDePasseVisible = false
    @State private var motDePasseConfirmeVisible = false

    var body: some View {
        VStack {
            // Fixed header (wave + back button)
            ZStack {
                VaguesVue()
                boutonRetour
            }
            .zIndex(1)
            
            Spacer()
            
            Text("create your account".localizedCapitalized)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 28, weight: .bold))
                .padding(.top, 50)
                .padding(.horizontal, 30)
            
            formulaire
                .padding(.top, 20)
            
            Spacer()

            boutonInscription
                .padding(.top, 50)
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .onDisappear {
            vm.resetErreurs()
        }
    }
    
    @ViewBuilder
    private var boutonRetour: some View {
        HStack {
            Button {
                dismiss()
                vm.resetChampsApresChangementDeVue()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 30))
                    .padding()
            }
            Spacer()
        }
        .padding(.leading, 16)
        .foregroundColor(.black)
    }
    
    @ViewBuilder
    private var boutonInscription: some View {
        Button {
            Task {
                let succes = await vm.inscriptionFirebase()
                if succes {
                    onInscriptionComplete()
                }
            }
        } label: {
            Text("continue".localizedCapitalized)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .cornerRadius(30)
                .padding(.horizontal, 50)
        }
    }
    
    @ViewBuilder
    private var formulaire: some View {
        VStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                ChampAvecIconeInfo(
                    texte: $vm.nomUtilisateur,
                    placeholder: "username *".localizedCapitalized,
                    erreur: $vm.nomUtilisateurErreur
                )
                .autocorrectionDisabled(true)
                Text(vm.nomUtilisateurErreur ?? " ").foregroundStyle(.red).font(.caption)
            }
            VStack(alignment: .leading, spacing: 4) {
                ChampSimple(
                    texte: $vm.courriel,
                    placeholder: "email *".localizedCapitalized,
                    erreur: $vm.courrielErreur
                )
                .autocorrectionDisabled(true)
                Text(vm.courrielErreur ?? " ").foregroundStyle(.red).font(.caption)
            }
            VStack(alignment: .leading, spacing: 4) {
                ChampAvecEyeAvecIconeInfo(
                    texte: $vm.motDePasse,
                    placeholder: "password *".localizedCapitalized,
                    estVisible: $motDePasseVisible,
                    erreur: $vm.motDePasseErreur
                )
                .autocorrectionDisabled(true)
                Text(vm.motDePasseErreur ?? " ").foregroundStyle(.red).font(.caption)
            }
            VStack(alignment: .leading, spacing: 4) {
                ChampAvecEye(
                    texte: $vm.motDePasseConfirme,
                    placeholder: "confirm password".localizedFirstCapitalized,
                    estVisible: $motDePasseConfirmeVisible,
                    erreur: $vm.motDePasseConfirmeeErreur
                )
                .autocorrectionDisabled(true)
                Text(vm.motDePasseConfirmeeErreur ?? " ").foregroundStyle(.red).font(.caption)
            }
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    InscriptionVue(vm: InscriptionVM(), onInscriptionComplete: {})
}
