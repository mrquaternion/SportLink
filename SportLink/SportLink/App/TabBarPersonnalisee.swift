//
//  TabBarPersonnalisee.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-16.
//

import SwiftUI

struct TabBarPersonnalisee: View {
    @Binding var ongletSelectionnee: Onglets
    @Binding var estPresente: Bool
    
    var body: some View {
        HStack {
            TabBarButton(
                imageName: ongletSelectionnee == .accueil ? "home_fill" : "home",
                title: "Home",
                isSelected: ongletSelectionnee == .accueil
            ) { ongletSelectionnee = .accueil }
            Spacer()
            TabBarButton(
                imageName: ongletSelectionnee == .explorer ? "discover_fill" : "discover",
                title: "Discover",
                isSelected: ongletSelectionnee == .explorer
            ) { ongletSelectionnee = .explorer }
            Spacer()
            TabBarButton(
                imageName: ongletSelectionnee == .creer ? "create_fill" : "create",
                title: "Create",
                isSelected: false // on ne veut pas sélectionner cet onglet
            ) {  estPresente = true }
            Spacer()
            TabBarButton(
                imageName: ongletSelectionnee == .activites ? "dashboard_fill" : "dashboard",
                title: "Dashboard",
                isSelected: ongletSelectionnee == .activites
            ) { ongletSelectionnee = .activites }
            Spacer()
            TabBarButton(
                imageName: ongletSelectionnee == .profil ? "profile_fill" : "profile",
                title: "Profil",
                isSelected: ongletSelectionnee == .profil
            ) { ongletSelectionnee = .profil }
        }
        .padding(.horizontal)
        .padding(.top, 4)
        .background( // source : https://stackoverflow.com/questions/68765679/swiftui-how-to-show-shadow-only-on-top-side
            Color.white
                .shadow(color: Color.black.opacity(0.15), radius: 4, y: 2)
                .mask { Rectangle().padding(.top, -20) }
                .ignoresSafeArea(edges: .bottom)
        )
    }
    
    struct TabBarButton: View {
        let imageName: String
        let title: String
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                VStack(spacing: 3) {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .foregroundColor(isSelected ? Color("CouleurParDefaut") : Color.gray)
                    Text(title)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(isSelected ? Color("CouleurParDefaut") : Color.gray)
                }
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    TabBarPersonnalisee(ongletSelectionnee: .constant(.accueil), estPresente: .constant(false))
}
