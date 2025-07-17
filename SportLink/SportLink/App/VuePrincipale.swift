import SwiftUI
import MapKit

enum Onglets: Int {
    case accueil, explorer, creer, activites, profil
}

struct VuePrincipale: View {
    @EnvironmentObject var serviceEmplacements: DonneesEmplacementService
    @StateObject private var activitesVM: ActivitesVM
    @State private var ongletSelectionne: Onglets = .accueil
    @State private var estPresente = false
    @State private var afficherTabBar = true
    
    init(serviceEmplacements: DonneesEmplacementService) {
        self._activitesVM = StateObject(wrappedValue: ActivitesVM(serviceEmplacements: serviceEmplacements))
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Group {
                    switch ongletSelectionne {
                    case .accueil:
                        AccueilVue()
                    case .explorer:
                        ExplorerVue(utilisateur: .constant(mockUtilisateur))
                            .environmentObject(serviceEmplacements)
                            .environmentObject(activitesVM)
                    case .creer:
                        Color.clear // ne sera jamais directement visible
                    case .activites:
                        ActivitesVue()
                            .environmentObject(serviceEmplacements)
                            .environmentObject(activitesVM)
                    case .profil:
                        ProfilVue()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                TabBarPersonnalisee(
                    ongletSelectionnee: $ongletSelectionne,
                    estPresente: $estPresente
                )
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .fullScreenCover(isPresented: $estPresente) {
                CreerActiviteVue(serviceEmplacements: serviceEmplacements)
                    .environmentObject(serviceEmplacements)
            }
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
    VuePrincipale(serviceEmplacements: DonneesEmplacementService())
        .environmentObject(DonneesEmplacementService())
}
