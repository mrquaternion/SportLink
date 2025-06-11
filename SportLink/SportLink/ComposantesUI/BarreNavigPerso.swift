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
    case activites = 2
    case profil    = 3
}

struct BarreNavigPerso: View {
    
    @Binding var ongletSelectionne : Onglets
    
    var body: some View {
        HStack(alignment: .center) {
            Button {
                ongletSelectionne = .accueil
            } label: {
                BarreNavigBouton(nomOnglet: "Home", nomImage: "home", estActif: ongletSelectionne == .accueil)
            }
            
            Spacer()
            
            Button {
                ongletSelectionne = .explorer
            } label: {
                BarreNavigBouton(nomOnglet: "Browse", nomImage: "browse", estActif: ongletSelectionne == .explorer)
            }
            
            Spacer()
            
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
            
            Spacer()
            
            Button {
                ongletSelectionne = .activites
            } label: {
                BarreNavigBouton(nomOnglet: "Activities", nomImage: "activities", estActif: ongletSelectionne == .activites)
            }
            
            Spacer()
            
            Button {
                ongletSelectionne = .profil
            } label: {
                BarreNavigBouton(nomOnglet: "Profil", nomImage: "profil", estActif: ongletSelectionne == .profil)
            }

        }
        .padding(.horizontal)
    }
}

#Preview {
    BarreNavigPerso(ongletSelectionne: .constant(.accueil))
}
