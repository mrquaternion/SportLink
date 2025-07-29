//
//  OverlaySauvegarde.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-17.
//

import SwiftUI

struct OverlaySauvegarde: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)

            Text("Informations enregistrées")
                .font(.headline)
                .foregroundColor(.green)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(radius: 10)
        .transition(.scale.combined(with: .opacity))
    }
}
