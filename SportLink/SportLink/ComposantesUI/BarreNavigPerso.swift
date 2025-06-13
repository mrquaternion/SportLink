//
//  BarreNavigPerso.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-10.
//

import SwiftUI

enum Onglets: Int {
    case accueil   = 0
    case explorer  = 1
    case creer     = 2
    case activites = 3
    case profil    = 4
}

struct BarreNavigPerso: View {
    
    @Binding var ongletSelectionne : Onglets
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Button {
                ongletSelectionne = .accueil
            } label: {
                BarreNavigBouton(nomOnglet: "Home", nomImage: "home", estActif: ongletSelectionne == .accueil)
            }
            
            
            Button {
                ongletSelectionne = .explorer
            } label: {
                BarreNavigBouton(nomOnglet: "Browse", nomImage: "browse", estActif: ongletSelectionne == .explorer)
            }
            
            
            Button {
                //
            } label: {
                VStack(alignment: .center, spacing: -2) {
                    Image("create")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 31.5, height: 39)
                    
                    
                    Text("Create")
                        .font(Font.custom("Blinker", size: 10))
                        .multilineTextAlignment(.center)
                    
                } .foregroundColor(.black)
            }
            .frame(width: 64, height: 64)
            
            
            Button {
                ongletSelectionne = .activites
            } label: {
                BarreNavigBouton(nomOnglet: "Activities", nomImage: "activities", estActif: ongletSelectionne == .activites)
            }
            
            
            Button {
                ongletSelectionne = .profil
            } label: {
                BarreNavigBouton(nomOnglet: "Profil", nomImage: "profil", estActif: ongletSelectionne == .profil)
            }
            
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 17)
        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
        .cornerRadius(25)
        .shadow(color: .black.opacity(0.3), radius: 4.9, x: 0, y: 4)
    }
}

#Preview {
    BarreNavigPerso(ongletSelectionne: .constant(.accueil))
}
