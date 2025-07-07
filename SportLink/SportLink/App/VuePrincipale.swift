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

struct VuePrincipale: View {
    
    @EnvironmentObject var emplacementsVM: DonneesEmplacementService
    
    @State var estPresente = false
    @State private var ongletSelectionne: Onglets = .accueil
    @State private var ancienOngletSelectionne: Onglets = .accueil
    // MARK: Mock
    @State private var utilisateur = Utilisateur(
        nomUtilisateur: "mathias13",
        courriel: "",
        photoProfil: "",
        disponibilites: [:],
        sportsFavoris: [],
        activitesFavoris: [],
        partenairesRecents: []
    )

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
            
            ExplorerVue(utilisateur: $utilisateur)
                .tabItem {
                    Image(ongletSelectionne == .explorer ? "browse_fill" : "browse")
                    Text("Browse")
                }
                .tag(Onglets.explorer)
                .environmentObject(emplacementsVM)
            
            
            Text("")
                .tabItem {
                    Image(ongletSelectionne == .creer ? "create_fill" : "create")
                    Text("Create")
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
        .onChange(of: ongletSelectionne) { oldValue, newValue in // source : https://stackoverflow.com/questions/64103934/swiftui-tab-view-display-sheet
            if ongletSelectionne == .creer {
                self.estPresente = true
                DispatchQueue.main.async {
                    self.ongletSelectionne = oldValue
                }
            } else {
                self.ancienOngletSelectionne = newValue
            }
        }
        .fullScreenCover(isPresented: $estPresente) {
            self.ongletSelectionne = self.ancienOngletSelectionne
        } content: {
            CreerActiviteVue()
                .environmentObject(emplacementsVM)
        }
    }
}

#Preview {
    VuePrincipale()
        .environmentObject(DonneesEmplacementService())
}

