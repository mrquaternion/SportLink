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
    let cercleDim: CGFloat = 18
    
    var body: some View {
        Button {
            UIApplication.shared.terminerEditage()
            withAnimation(.linear(duration: 0.2)) { afficherFiltreOverlay.toggle() }
        } label: {
            Image("filter_map")
                .resizable()
                .scaledToFit()
                .frame(width: cercleDim, height: cercleDim)
                .foregroundStyle(.black)
                .padding(8)
                .background(
                    Circle()
                        .strokeBorder(Color(.systemGray4), lineWidth: 1)
                )
        }
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
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    BoutonFiltrage(afficherFiltreOverlay: .constant(false), dateAFiltree: .constant(.now))
}
