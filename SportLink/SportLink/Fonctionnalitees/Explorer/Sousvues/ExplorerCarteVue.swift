//
//  ExplorerCarteVue.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-20.
//

import SwiftUI
import MapKit

private let delta = 0.02

struct ExplorerCarteVue: View {
    @EnvironmentObject var vm: DonneesEmplacementService
    @State var location: CLLocation? = {
        if let coord = UserDefaults.standard.dernierePosition {
            return CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        }
        return nil
    }()
    @State private var position: MapCameraPosition = .automatic
    @State private var aCentreSurUtilisateur = false
    @State private var selectionne: Parc?
    @State private var carteCentree = false
    @State private var recentrer = false
    @State private var aInteragiAvecCarte = false

    
    var body: some View {
        // Carte
        ZStack(alignment: .bottomTrailing) {
            CarteClusterVue(
                parcs: vm.parcs,
                infras: vm.infrastructures,
                localisationUtilisateur: location,
                centrerCarte: !carteCentree,
                selectionne: $selectionne,
                recentrer: $recentrer,
                aInteragiAvecCarte: $aInteragiAvecCarte
            )
            .edgesIgnoringSafeArea(.all)
            
            Button  {
                selectionne = nil
                recentrer = true
            } label: {
                Image(systemName: "location.fill")
                    .font(.title2)
                    .padding(10)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
            .padding([.top, .leading, .trailing])
            .padding(.bottom, 20)
        }
        .task {
            LocationManager.shared.checkAuthorization()

            if let coord = location?.coordinate {
                UserDefaults.standard.dernierePosition = coord
            }

            if !aCentreSurUtilisateur {
                do {
                    let nouvellePosition = try await LocationManager.shared.currentLocation

                    if !aInteragiAvecCarte {
                        self.location = nouvellePosition
                        aCentreSurUtilisateur = true
                    }
                } catch {
                    print("Erreur de localisation: \(error)")
                }
            }
        }
    }
}

#Preview {
    ExplorerCarteVue()
        .environmentObject(DonneesEmplacementService())
}
