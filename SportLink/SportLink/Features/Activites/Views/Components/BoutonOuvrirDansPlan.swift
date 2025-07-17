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
        Button(action: {
            ouvrirDansPlans()
        }) {
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

    private func ouvrirDansPlans() {
        let latitude = coordonnees.latitude
        let longitude = coordonnees.longitude
        let urlString = "http://maps.apple.com/?daddr=\(latitude),\(longitude)&dirflg=d"

        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
