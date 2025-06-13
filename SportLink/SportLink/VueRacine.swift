//
//  ContentView.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-01.
//

import SwiftUI

struct VueRacine: View {
    
    @State private var ongletSelectionne: Onglets = .accueil
    
    var body: some View {
        TabView(selection: $ongletSelectionne) {
            VueAccueil()
                .tabItem {
                    Image(ongletSelectionne == .accueil ? "home_fill" : "home")
                    Text("Home")
                }
                .tag(Onglets.accueil)
            
            Text("Explorer Vue")
                .tabItem {
                    Image(ongletSelectionne == .explorer ? "browse_fill" : "browse")
                    Text("Browse")
                }
                .tag(Onglets.explorer)
            
            
            Text("Créer Vue")
                .tabItem {
                    Image("create_fill")
                    Text("Create")
                        .foregroundStyle(.black)
                }
                .tag(Onglets.creer)
            
            
            Text("Activités Vue")
                .tabItem {
                    Image(ongletSelectionne == .activites ? "activities_fill" : "activities")
                    Text("Activities")
                }
                .tag(Onglets.activites)
            
            
            Text("Profil Vue")
                .tabItem {
                    Image(ongletSelectionne == .profil ? "profile_fill" : "profile")
                    Text("Profil")
                }
                .tag(Onglets.profil)
        }
        .tint(Color("CouleurParDefaut"))
    }
}

#Preview {
    VueRacine()
}

