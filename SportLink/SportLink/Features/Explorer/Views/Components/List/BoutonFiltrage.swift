//
//  BoutonFiltrage.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-13.
//

import SwiftUI

struct BoutonFiltrage: View {
    @Binding var afficherFiltreOverlay: Bool
    @Binding var dateAFiltree: Date
    let cercleDim: CGFloat = 26
    
    var body: some View {
        Button {
            withAnimation { afficherFiltreOverlay.toggle() }
        } label: {
            Image("filter_map")
                .resizable()
                .scaledToFit()
                .frame(width: cercleDim, height: cercleDim)
                .font(.title3)
                .foregroundStyle(.black)
                .padding(14)
                .background(Color(.secondarySystemBackground))
                .clipShape(Circle())
        }
        .shadow(
            color: .black.opacity(0.15),
            radius: 10, x: 0, y: 0
        )
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    BoutonFiltrage(afficherFiltreOverlay: .constant(false), dateAFiltree: .constant(.now))
}
