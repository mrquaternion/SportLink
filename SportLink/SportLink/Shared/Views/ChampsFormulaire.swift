//
//  ChampsFormulaire.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-25.
//

import SwiftUI

struct ChampSimple: View {
    @Binding var texte: String
    let placeholder: String
    @Binding var erreur: String?

    var body: some View {
        TextField(placeholder, text: $texte)
            .autocapitalization(.none)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).stroke(erreur != nil ? Color.red : Color.gray.opacity(0.6)))
            .accessibilityIdentifier("champDeTexte")
    }
}

struct ChampAvecEye: View {
    @Binding var texte: String
    let placeholder: String
    @Binding var estVisible: Bool
    @Binding var erreur: String?
    
    var body: some View {
        HStack {
            if estVisible {
                TextField(placeholder, text: $texte)
                    .accessibilityIdentifier("champAvecOeilDesactive")
            } else {
                SecureField(placeholder, text: $texte)
                    .accessibilityIdentifier("champAvecOeilActive")
            }
            Button {
                estVisible.toggle()
            } label: {
                Image(systemName: estVisible ? "eye" : "eye.slash")
                    .foregroundColor(.gray)
            }
            .accessibilityIdentifier("basculerVisibiliteMDP")
        }
        .autocapitalization(.none)
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).stroke(erreur != nil ? Color.red : Color.gray.opacity(0.6)))
    }
}

struct ChampAvecIconeInfo: View {
    @Binding var texte: String
    let placeholder: String
    @Binding var erreur: String?
    
    var body: some View {
        HStack {
            Image(systemName: "info.circle")
                .foregroundColor(.black)
            TextField(placeholder, text: $texte)
                .accessibilityIdentifier("champDeTexte")
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).stroke(erreur != nil ? Color.red : Color.gray.opacity(0.6)))
    }
}

struct ChampAvecEyeAvecIconeInfo: View {
    @Binding var texte: String
    let placeholder: String
    @Binding var estVisible: Bool
    @Binding var erreur: String?
    
    var body: some View {
        HStack {
            Image(systemName: "info.circle")
                .foregroundColor(.black)
            if estVisible {
                TextField(placeholder, text: $texte)
                    .accessibilityIdentifier("champAvecOeilDesactive")
            } else {
                SecureField(placeholder, text: $texte)
                    .accessibilityIdentifier("champAvecOeilActive")
            }
            Button {
                estVisible.toggle()
            } label: {
                Image(systemName: estVisible ? "eye" : "eye.slash")
                    .foregroundColor(.gray)
            }
            .accessibilityIdentifier("basculerVisibiliteMDP")
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).stroke(erreur != nil ? Color.red : Color.gray.opacity(0.6)))
    }
}
