//
//  ActiviteDetails.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-14.
//

import SwiftUI

struct DetailsActivite: View {
    @Environment(\.dismiss) private var dismiss
    
    let activite: Activite
    
    var body: some View {
        contenu
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left.circle.fill")
                            .font(.title3)
                            .foregroundColor(Color("CouleurParDefaut"))
                            .padding(3)
                            .background(.thinMaterial, in: Circle())
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("\(activite.sport.capitalized) activity")
                        .font(.headline)
                }
            }
            .navigationBarBackButtonHidden(true)
    }
    
    private var contenu: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
    
}

#Preview {
    let mockActivite =
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
    
    DetailsActivite(activite: mockActivite)
}
