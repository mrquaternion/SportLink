//
//  BarreDeRecherche.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-12.
//

import SwiftUI

struct BarreDeRecherche: View {
    @Binding var texteDeRecherche: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color(.systemGray2))
            
            TextField("Search by title or parc", text: $texteDeRecherche)
                .autocorrectionDisabled(true)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color(.systemGray2))
                        .padding()
                        .offset(x: 10)
                        .opacity(texteDeRecherche.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.terminerEditage()
                            texteDeRecherche = ""
                        }
                    , alignment: .trailing
                )
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(.systemGray6))
                .shadow(
                    color: .black.opacity(0.15),
                    radius: 10, x: 0, y: 0
                )
        )
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    BarreDeRecherche(texteDeRecherche: .constant("dsdsd"))
}
