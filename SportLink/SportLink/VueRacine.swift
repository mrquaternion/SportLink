//
//  ContentView.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-01.
//

import SwiftUI

struct VueRacine: View {
    
    @State var ongletSelectionne : Onglets = .accueil
    
    var body: some View {
        Spacer()
        
        BarreNavigPerso(ongletSelectionne: $ongletSelectionne)
    }
}

#Preview {
    VueRacine()
}

