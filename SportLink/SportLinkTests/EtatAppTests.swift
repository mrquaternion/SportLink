//
//  AppStateTests.swift
//  SportLinkTests
//
//  Created by Mathias La Rochelle on 2025-07-31.
//

import Testing
import Foundation
import SwiftUI
@testable import SportLink

@MainActor
struct EtatAppTests {    
    @Test("Performance de l'app sous événements rapides")
    func appVMPerformance() {
        let appVM = AppVM()
        
        let tabs: [Onglets] = [.accueil, .explorer, .activites, .profil]
        
        for _ in 0..<1000 {
            for tab in tabs {
                appVM.ongletSelectionne = tab
            }
        }
        
        
        #expect(appVM.ongletSelectionne == .profil)
    }
}
