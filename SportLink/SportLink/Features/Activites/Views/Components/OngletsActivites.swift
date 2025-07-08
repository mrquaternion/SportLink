//
//  ExplorerActiviteVue.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-08.
//


import SwiftUI

struct OngletsActivites: View {
    @Binding var selection: Onglet

    enum Onglet: String, CaseIterable {
        case hosted = "Hosted"
        case going = "Going"
        case bookmarked = "Bookmarked"
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Onglet.allCases, id: \.self) { onglet in
                Button(action: {
                    selection = onglet
                }) {
                    Text(onglet.rawValue)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(selection == onglet ? .white : .black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(selection == onglet ? Color.red : Color.red.opacity(0.2))
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding()
    }
}

#Preview {
    OngletsActivites(selection: .constant(.hosted))
}
