//
//  RecherchePOIVue.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-29.
//

import SwiftUI
import MapKit

struct BoutonOuvrirMaps: View {
    @StateObject var recherchePOI = RecherchePOIVM()
    @State private var afficherConfirmation = false
    @State private var itemMaps: MKMapItem? = nil
    var parc: Parc
    
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
            Label("Open in Maps", systemImage: "arrow.up.right.square")
        }
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
        return BoutonOuvrirMaps(
            parc: vm.parcs.first { $0.nom == "Rutherford" }!
        )
    }
}
