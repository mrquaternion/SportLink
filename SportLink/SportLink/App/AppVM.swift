//
//  Untitled.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-30.
//

import Foundation
import SwiftUI

@MainActor
final class AppVM: ObservableObject {
    @Published var ongletSelectionne: Onglets = .accueil
    @Published var sousOngletSelectionne: SousOnglets = .organise {
        didSet {
            guard sousOngletSelectionne != antecedent else { return }
            // decide insertion/removal based on rawValue
            aInserer = sousOngletSelectionne.rawValue > antecedent.rawValue
                ? .move(edge: .leading)
                : .move(edge: .trailing)
            aDegager = sousOngletSelectionne.rawValue > antecedent.rawValue
                ? .move(edge: .trailing)
                : .move(edge: .leading)
            
            // animate trigger change
            withAnimation {
                trigger = sousOngletSelectionne
                antecedent = sousOngletSelectionne
            }
        }
    }
    
    @Published var trigger: SousOnglets = .organise
    private(set) var antecedent: SousOnglets = .organise
    
    var aInserer: AnyTransition = .move(edge: .leading)
    var aDegager: AnyTransition = .move(edge: .trailing)
}
