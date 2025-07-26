//
//  VueActivites.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-15.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case organise = "Hosting"
    case participe = "Going"
    case favoris = "Bookmarked"
}

struct ActivitesVue: View {
    @EnvironmentObject var serviceEmplacements: DonneesEmplacementService
    @EnvironmentObject var activitesVM: ActivitesVM
    @StateObject private var contexte = TabControllerContext()
    
    @Namespace var line

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(alignment: .center) {
                    Text("Your dashboard")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(.top, 10)
                    
                    HStack {
                        ForEach(Tab.allCases, id: \.self) { tab in
                            VStack {
                                Button {
                                    withAnimation {
                                        contexte.selectionnee = tab
                                    }
                                } label: {
                                    Text(tab.rawValue)
                                        .font(.headline)
                                        .foregroundColor(contexte.selectionnee == tab ? .primary : .gray)
                                }
                                .frame(maxWidth: .infinity)
                                
                                ZStack {
                                    Rectangle().fill(Color("CouleurParDefaut"))
                                        .frame(height: 1)
                                        .opacity(0)
                                    
                                    if contexte.selectionnee == tab {
                                        Rectangle().fill(Color("CouleurParDefaut"))
                                            .frame(height: 1)
                                            .matchedGeometryEffect(id: "tab", in: line)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                
                ZStack {
                    if contexte.trigger == .organise {
                        ActivitesOrganiseesVue(serviceEmplacements: serviceEmplacements)
                            .environmentObject(activitesVM)
                            .transition(.asymmetric(
                                insertion: contexte.aInserer,
                                removal: contexte.aDegager
                            ))
                    }
                    if contexte.trigger == .participe  {
                        ActivitesInscritesVue()
                            .transition(.asymmetric(
                                insertion: contexte.aInserer,
                                removal: contexte.aDegager
                            ))
                    }
                    if contexte.trigger == .favoris {
                        ActivitesFavoritesVue()
                            .transition(.asymmetric(
                                insertion: contexte.aInserer,
                                removal: contexte.aDegager
                            ))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color(.systemGray6))
        }
    }
}

final class TabControllerContext: ObservableObject {
    @Published var selectionnee: Tab = .organise {
        didSet {
            guard selectionnee != antecedent else { return }
            // decide insertion/removal based on rawValue
            aInserer = selectionnee.rawValue > antecedent.rawValue
                ? .move(edge: .leading)
                : .move(edge: .trailing)
            aDegager = selectionnee.rawValue > antecedent.rawValue
                ? .move(edge: .trailing)
                : .move(edge: .leading)
            
            // animate trigger change
            withAnimation {
                trigger = selectionnee
                antecedent = selectionnee
            }
        }
    }
    
    @Published var trigger: Tab = .organise
    private(set) var antecedent: Tab = .organise
    
    var aInserer: AnyTransition = .move(edge: .leading)
    var aDegager:   AnyTransition = .move(edge: .trailing)
}

#Preview {
    ActivitesVue()
        .environmentObject(DonneesEmplacementService())
        .environmentObject(ActivitesVM(serviceEmplacements: DonneesEmplacementService()))
        .environmentObject(TabControllerContext())
}



