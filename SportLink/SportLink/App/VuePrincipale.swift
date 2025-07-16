import SwiftUI
import MapKit

enum Onglets: Int {
    case accueil, explorer, creer, activites, profil
}

struct VuePrincipale: View {
    @EnvironmentObject var serviceEmplacements: DonneesEmplacementService
    @EnvironmentObject var tabBarEtat: TabBarEtat
    @State private var ongletSelectionne: Onglets = .accueil
    @State private var estPresente = false
    @State private var afficherTabBar = true

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch ongletSelectionne {
                case .accueil:
                    AccueilVue()
                case .explorer:
                    ExplorerVue(utilisateur: .constant(mockUtilisateur))
                        .environmentObject(serviceEmplacements)
                case .creer:
                    Color.clear // ne sera jamais directement visible
                case .activites:
                    ActivitesVue()
                case .profil:
                    ProfilVue()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    
        
            TabBarPersonnalisee(
                ongletSelectionnee: $ongletSelectionne,
                estPresente: $estPresente
            )
            .offset(y: tabBarEtat.estVisible ? 0 : UIScreen.main.bounds.height)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .fullScreenCover(isPresented: $estPresente) {
            CreerActiviteVue(serviceEmplacements: serviceEmplacements)
                .environmentObject(serviceEmplacements)
        }
    }

    private var mockUtilisateur: Utilisateur {
        Utilisateur(
            nomUtilisateur: "mathias13",
            courriel: "",
            photoProfil: "",
            disponibilites: [:],
            sportsFavoris: [],
            activitesFavoris: [],
            partenairesRecents: []
        )
    }
}


#Preview {
    VuePrincipale()
        .environmentObject(DonneesEmplacementService())
}
