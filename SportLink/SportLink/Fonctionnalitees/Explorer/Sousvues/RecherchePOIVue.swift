//
//  RecherchePOIVue.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-29.
//

import SwiftUI
import MapKit

struct RecherchePOIVue: View {
    @StateObject var recherchePOI = RecherchePOIVM()
    
    var parc: Parc
    
    @State private var afficherConfirmation = false
    @State private var itemMaps: MKMapItem? = nil
    
    var body: some View {
        Button {
            recherchePOI.ouvrirParcDansMaps(for: parc) { item in
                if let item = item {
                    itemMaps = item
                    afficherConfirmation = true
                } else {
                    print("Aucun parc trouvé.")
                }
            }
        } label: {
            HStack {
                Image(systemName: "mappin.and.ellipse")
                
                (
                    Text("See ") +
                    Text(parc.nom!)
                        .foregroundColor(Color("CouleurParDefaut"))
                        .bold() +
                    Text(" details")
                )
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .foregroundColor(.primary)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.black, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .alert("Opening in Apple Maps", isPresented: $afficherConfirmation, actions: {
            Button("Close", role: .cancel) { }
            Button("Open") {
                itemMaps?.openInMaps()
            }
        }, message: {
            Text("Do you really want to open the location of the parc in Apple Maps?")
        })
    }
}

#Preview {
    PreviewContent.recherchePOIVue
}

private struct PreviewContent {
    static var recherchePOIVue: some View {
        let vm = DonneesEmplacementService()
        vm.chargerDonnees()
        return RecherchePOIVue(
            parc: vm.parcs.first { $0.nom == "Rutherford" }!
        )
    }
}
