//
//  ActiviteDetails.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-14.
//

import SwiftUI

struct DetailsActivite: View {
    let activite: Activite
    let namespace: Namespace.ID
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .matchedTransitionSource(id: activite.id, in: namespace)
    }
}

#Preview {
    PreviewWrapper()
}

private struct PreviewWrapper: View {
    @Namespace private var ns

    // Exemple minimal d'Activite (à adapter à votre modèle)
    private var mockActivite: Activite {
        Activite(
            titre: "Match amical",
            organisateurId: UtilisateurID(valeur: "demo"),
            infraId: "081-0090",
            sport: .soccer,
            date: DateInterval(start: .now, duration: 3600),
            nbJoueursRecherches: 6,
            participants: [],
            description: "Venez vous amuser !",
            statut: .ouvert,
            invitationsOuvertes: true,
            messages: []
        )
    }

    var body: some View {
        DetailsActivite(
            activite: mockActivite,
            namespace: ns
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
