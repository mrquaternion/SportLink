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
    @StateObject var utilisateurConnecteVM = UtilisateurConnecteVM()
    
    var body: some Scene {
        WindowGroup {
            EcranDemarrageVue()
                .environmentObject(emplacementsVM)
                .environmentObject(utilisateurConnecteVM)
                .onAppear {
                    emplacementsVM.chargerDonnees()
                }
        }
    }
}
