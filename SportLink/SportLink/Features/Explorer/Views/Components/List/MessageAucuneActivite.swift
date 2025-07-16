//
//  MessageAucuneActivite.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-15.
//

import SwiftUI

struct MessageAucuneActivite: View {
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Image(systemName: "figure.run")
                .font(.system(size: 60))
            Text("No activity has been organized \n for the selected settings")
                .font(.title2)
                .multilineTextAlignment(.center)
        }
        .foregroundColor(.gray)
    }
}

#Preview {
    MessageAucuneActivite()
}
