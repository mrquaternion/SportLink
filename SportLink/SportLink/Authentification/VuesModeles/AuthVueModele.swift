//
//  AuthVueModele.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-17.
//

import Foundation
import SwiftUI

class AuthVueModele: ObservableObject {
    
    @State var nomUtilisateur = ""
    @State var courriel = ""
    @State var motDePasse = ""
    @State var motDePasseConfirme = ""
    
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
