//
//  VueExplorer.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-15.
//

import SwiftUI

struct ExplorerVue: View {
    @State private var modeAffichage: ModeAffichage = .liste
    @EnvironmentObject var emplacementsVM: DonneesEmplacementService
    
    var body: some View {
        ZStack {
            VStack {
                if modeAffichage == .liste {
                    ExplorerListeVue()
                } else {
                    ExplorerCarteVue()
                        .environmentObject(emplacementsVM)
                }
            }
            
            VStack {
                Spacer()
                
                BoutonSwitchExplorer(modeAffichage: $modeAffichage)
                    .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    ExplorerVue()
        .environmentObject(DonneesEmplacementService())
}
