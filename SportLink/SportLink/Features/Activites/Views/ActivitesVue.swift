//
//  VueActivites.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-15.
//



import SwiftUI

struct ActivitesVue: View {
    @EnvironmentObject var serviceEmplacements: DonneesEmplacementService
    @State private var selection: OngletsActivites.Onglet = .hosted
    @State private var cacherOnglets = false

    var body: some View {
        ZStack(alignment: .top) {
            Group {
                switch selection {
                case .hosted:
                    ActivitesOrganiseesVue(serviceEmplacements: serviceEmplacements, cacherOnglets: $cacherOnglets)
                case .going:
                    ActivitesInscritesVue()
                case .bookmarked:
                    ActivitesFavoritesVue()
                }
            }
           
            OngletsActivites(selection: $selection)
                .padding(.top, 40)
                .opacity(cacherOnglets ? 0.0 : 1.0)
                .allowsHitTesting(!cacherOnglets)
                .animation(.easeInOut(duration: 0.2), value: cacherOnglets)
        }
    }
}

#Preview {
    ActivitesVue()
        .environmentObject(DonneesEmplacementService())
        .environmentObject(ActivitesVM(serviceEmplacements: DonneesEmplacementService()))
}



