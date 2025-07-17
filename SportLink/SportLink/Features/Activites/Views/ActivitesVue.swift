//
//  VueActivites.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-15.
//



import SwiftUI

struct ActivitesVue: View {
    @EnvironmentObject var serviceEmplacements: DonneesEmplacementService
    @EnvironmentObject var activitesVM: ActivitesVM
    @State private var selection: OngletsActivites.Onglet = .hosted

    var body: some View {
        ZStack(alignment: .top) {
            Color(.systemGray6)
                .ignoresSafeArea()
            
            Group {
                switch selection {
                case .hosted:
                    ActivitesOrganiseesVue(serviceEmplacements: serviceEmplacements)
                        .environmentObject(activitesVM)
                case .going:
                    ActivitesInscritesVue()
                case .bookmarked:
                    ActivitesFavoritesVue()
                }
            }
            
            OngletsActivites(selection: $selection)
                .padding(.top, 40)
                .padding(.bottom, 15)
                .background(Color(.systemGray6))
        }
    }
}

#Preview {
    ActivitesVue()
        .environmentObject(DonneesEmplacementService())
        .environmentObject(ActivitesVM(serviceEmplacements: DonneesEmplacementService()))
}



