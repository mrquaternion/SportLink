//
//  VueActivites.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-15.
//



import SwiftUI

struct ActivitesVue: View {
    @State private var selection: OngletsActivites.Onglet = .hosted

    var body: some View {
        VStack {
            OngletsActivites(selection: $selection)
                .padding(.top, 50)
                .zIndex(1)
            
            Group {
                switch selection {
                case .hosted:
                    HostedVue()
                case .going:
                    GoingVue()
                case .bookmarked:
                    BookmarkedVue()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    ActivitesVue()
        .environmentObject(DonneesEmplacementService())
}



