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
            withAnimation(.linear(duration: 0.2)) { afficherFiltreOverlay.toggle() }
        } label: {
            Image("filter_map")
                .resizable()
                .scaledToFit()
                .frame(width: cercleDim, height: cercleDim)
                .font(.title3)
                .foregroundStyle(.black)
                .padding(14)
                .background(Color(.systemGray5))
                .clipShape(Circle())
        }
        .shadow(
            color: .black.opacity(0.1),
            radius: 10, x: 0, y: 0
        )
        .opacity(afficherFiltreOverlay ? 0.2 : 1.0)
        .buttonStyle(.plain)
    }
}

struct BoiteFiltrage: View {
    @EnvironmentObject var vm: ExplorerListeVM

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sports")
                .font(.headline)
            Divider()
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Sport.allCases, id: \.self) { sport in
                    HStack {
                        Button {
                            if vm.sportsChoisis.contains(sport.nom) { vm.sportsChoisis.remove(sport.nom) }
                            else { vm.sportsChoisis.insert(sport.nom) }
                        } label: {
                            HStack {
                                Image(systemName: sport.icone)
                                Text(sport.nom.capitalized)
                                Spacer()
                                Image(systemName: vm.sportsChoisis.contains(sport.nom) ? "checkmark.square.fill" : "square")
                            }
                            .foregroundColor(.black)
                        }
                    }
                    
                    Divider()
                }
            }
            .frame(maxWidth: .infinity)
            
            DatePicker(
                "Date",
                selection: $vm.dateAFiltree,
                in: vm.dateMin...vm.dateMax,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .font(.headline)
            .padding(.top, 20)
        }
        .padding()
        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    BoutonFiltrage(afficherFiltreOverlay: .constant(false), dateAFiltree: .constant(.now))
}
