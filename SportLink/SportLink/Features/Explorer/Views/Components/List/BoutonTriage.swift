//
//  BoutonTriage.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-13.
//

import SwiftUI

struct BoutonTriage: View {
    @Binding var optionTri: OptionTri
    
    var body: some View {
        Menu {
            Button { optionTri = .date } label: {
                let estSelectionne = optionTri == .date ? "✓" : ""
                Text(estSelectionne + " Time ascending")
            }
            Button { optionTri = .dateInv } label: {
                let estSelectionne = optionTri == .dateInv ? "✓" : ""
                Text(estSelectionne + " Time descending")
            }
            Button { optionTri = .distance } label: {
                let estSelectionne = optionTri == .distance ? "✓" : ""
                Text(estSelectionne + " Distance ascending")
            }
            Button { optionTri = .distanceInv } label: {
                let estSelectionne = optionTri == .distanceInv ? "✓" : ""
                Text(estSelectionne + " Distance descending")
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
                .font(.title3)
                .foregroundStyle(.black)
                .padding(14)
                .background(Color(.systemGray5))
                .clipShape(Circle())
                .shadow(
                    color: .black.opacity(0.1),
                    radius: 10, x: 0, y: 0
                )
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    BoutonTriage(optionTri: .constant(.date))
}
