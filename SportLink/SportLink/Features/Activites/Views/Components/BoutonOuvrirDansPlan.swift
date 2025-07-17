//
//  BoutonOuvrirDansPlan.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-16.
//

//
//  BoutonOuvrirDansPlans.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-16.
//

import SwiftUI
import MapKit

struct BoutonOuvrirDansPlans: View {
    let coordonnees: CLLocationCoordinate2D

    var body: some View {
        Button {
            ouvrirRouteDansAppleMaps()
        } label: {
            HStack {
                Image(systemName: "map")
                Text("Ouvrir dans Plans")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
    
    func ouvrirRouteDansAppleMaps() {
        let coordonneesDestination = coordonnees
        let repereDestination = MKPlacemark(coordinate: coordonneesDestination)
        let itemMapDestination = MKMapItem(placemark: repereDestination)
        itemMapDestination.name = "Infrastructure XXXX"
        
        itemMapDestination.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
}
