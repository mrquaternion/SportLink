//
//  EcranDemarrage.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-09.
//

import SwiftUI


enum EtatAuthentification {
    case chargement
    case nonAuthentifie
    case authentifie
}

struct EcranDemarrageVue: View {
    @EnvironmentObject var serviceEmplacements: DonneesEmplacementService
    @EnvironmentObject var utilisateurConnecteVM: UtilisateurConnecteVM
    @State private var etatAuthentification: EtatAuthentification = .chargement

    var body: some View {
        Group {
            switch etatAuthentification {
            case .chargement:
                SplashScreen()
            case .nonAuthentifie:
                AuthentificationVue { nouvelEtat in
                    etatAuthentification = nouvelEtat
                }
            case .authentifie:
                VuePrincipale(
                    serviceEmplacements: serviceEmplacements,
                    utilisateurConnecteVM: utilisateurConnecteVM,
                    onDeconnexion: {
                        etatAuthentification = .nonAuthentifie
                    }
                )
            }
        }
        .onAppear {
            verifierAuthentificationAuDemarrage()
        }
    }
    
    private func verifierAuthentificationAuDemarrage() {
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 secs
            
            let nouvelEtat = await GestionnaireAuthentification.partage.verifierEtatAuthentification()
            
            await MainActor.run {
                etatAuthentification = nouvelEtat
            }
        }
    }
}

#Preview {
    EcranDemarrageVue()
        .environmentObject(DonneesEmplacementService())
}
