//
//  ModifierVue.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-17.
//

// NouvelleVueEdition.swift

import SwiftUI

struct ModifierVue: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .padding()
                .foregroundColor(.blue)
                .font(.headline)

                Spacer()
            }

            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
}
