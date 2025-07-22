//
//  RecherchePOIVue.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-29.
//

import SwiftUI
import MapKit

struct BoutonOuvrirMaps: View {
    @Binding var afficherConfirmation: Bool
    @Binding var itemMap: MKMapItem?
    let etiquette: Label<Text, Image>
    let texteAlerte: String
    let fetchItemMap: (@escaping (MKMapItem?) -> Void) -> Void
    var optionsLancement: [String: Any]?
    
    var body: some View {
        Button {
            fetchItemMap { item in
                if let item = item {
                    itemMap = item
                    afficherConfirmation = true
                }
            }
        } label: { etiquette }
        .alert("Opening in Apple Maps", isPresented: $afficherConfirmation, actions: {
            Button("Close", role: .cancel) { }
            Button("Open") {
                if let opts = optionsLancement {
                    itemMap?.openInMaps(launchOptions: opts)
                } else {
                    itemMap?.openInMaps()
                }
            }
        }, message: {
            Text("Do you really want to open the \(texteAlerte) in Apple Maps?")
        })
    }
}

private struct BoutonOuvrirMaps_Previews: PreviewProvider {
    static let mockItem: MKMapItem = {
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522))
        let item = MKMapItem(placemark: placemark)
        item.name = "Mock Parc"
        return item
    }()
    
    static var previews: some View {
        BoutonOuvrirMaps(
            afficherConfirmation: .constant(true),
            itemMap: .constant(mockItem),
            etiquette: Label("Open in Maps", systemImage: "arrow.up.right.square"),
            texteAlerte: "parc",
            fetchItemMap: { completion in
                // Simule la récupération du MKMapItem
                completion(mockItem)
            },
            optionsLancement: nil
        )
        .previewDisplayName("Ouvre un parc")
        .padding()
    }
}
