//
//  BoutonTriage.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-13.
//

import SwiftUI

struct BoutonTriage: View {
    @Binding var optionTri: OptionTri
    
    let cercleDim: CGFloat = 22
    
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
                .resizable()
                .scaledToFit()
                .frame(width: cercleDim, height: cercleDim)
                .foregroundStyle(.black)
                .padding(10)
                .background(
                    Circle()
                        .fill(Color.white)
                )
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    BoutonTriage(optionTri: .constant(.date))
}
