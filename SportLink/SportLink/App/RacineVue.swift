//
//  ContentView.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-01.
//

import SwiftUI
import MapKit

enum Onglets: Int {
    case accueil = 0
    case explorer = 1
    case creer = 2
    case activites = 3
    case profil = 4
}

struct RacineVue: View {
    
    @EnvironmentObject var emplacementsVM: DonneesEmplacementService
    @State private var ongletSelectionne: Onglets = .accueil
    
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.white
        UITabBar.appearance().standardAppearance = tabBarAppearance

        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    var body: some View {
        TabView(selection: $ongletSelectionne) {
            AccueilVue()
                .tabItem {
                    Image(ongletSelectionne == .accueil ? "home_fill" : "home")
                    Text("Home")
                }
                .tag(Onglets.accueil)
            
            ExplorerVue()
                .tabItem {
                    Image(ongletSelectionne == .explorer ? "browse_fill" : "browse")
                    Text("Browse")
                }
                .tag(Onglets.explorer)
                .environmentObject(emplacementsVM)
            
            
            Text("Vue de la création d'une activité")
                .tabItem {
                    Image("create_fill")
                    Text("Create")
                        .foregroundStyle(.black)
                }
                .tag(Onglets.creer)
            
            
            ActivitesVue()
                .tabItem {
                    Image(ongletSelectionne == .activites ? "activities_fill" : "activities")
                    Text("Activities")
                }
                .tag(Onglets.activites)
            
            
            ProfilVue()
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
    RacineVue()
        .environmentObject(DonneesEmplacementService())
}

