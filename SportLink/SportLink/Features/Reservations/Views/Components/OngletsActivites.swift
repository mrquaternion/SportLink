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
                Button {
                    selection = onglet
                } label: {
                    Text(onglet.rawValue)
                        .font(.system(size: 15))
                        .fontWeight(selection == onglet ? .bold : .regular)
                        .foregroundColor(selection == onglet ? .white : .black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(selection == onglet ? Color.red : Color.red.opacity(0.2))
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal, 40)
    }
}

#Preview {
    OngletsActivites(selection: .constant(.hosted))
        .environmentObject(DonneesEmplacementService())
}
