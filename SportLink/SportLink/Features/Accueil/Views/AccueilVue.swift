//
//  VueAccueil.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-12.
//

import SwiftUI

struct AccueilVue: View {
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            
            Text("Vue de l'accueil")
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AccueilVue()
}
