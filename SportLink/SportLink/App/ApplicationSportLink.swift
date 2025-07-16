//
//  SportLinkApp.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-01.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
      FirebaseApp.configure()

      return true
    }
}

@main
struct ApplicationSportLink: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var emplacementsVM = DonneesEmplacementService()
    @StateObject private var tabBarEtat = TabBarEtat()
    
    var body: some Scene {
        WindowGroup {
            VuePrincipale()
                .environmentObject(emplacementsVM)
                .environmentObject(tabBarEtat)
                .onAppear {
                    emplacementsVM.chargerDonnees()
                }
        }
    }
}
