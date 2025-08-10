//
//  MessageAucuneActivite.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-15.
//

import SwiftUI

struct MessageAucuneActivite: View {
    let texte: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Image(systemName: "figure.run")
                .font(.system(size: 60))
            Text(texte.localizedFirstCapitalized)
                .font(.title2)
                .multilineTextAlignment(.center)
        }
        .foregroundColor(.gray)
    }
}

#Preview {
    MessageAucuneActivite(texte: "no activity has been organized \n for the selected settings")
}
