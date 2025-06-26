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
    @State private var parcSelectionne: Parc?
    @State private var infraSelectionnee: Infrastructure?
    @State private var centrageInitial = true
    @State private var demandeRecentrage = false
    @State private var aInteragiAvecCarte = false
    @State private var deselectionnerAnnotation = false
    
    var body: some View {
        // Carte
        ZStack(alignment: .bottomTrailing) {
            CarteVue(
                parcs: vm.parcs,
                infras: vm.infrastructures,
                localisationUtilisateur: location,
                centrageInitial: $centrageInitial,
                demandeRecentrage: $demandeRecentrage,
                parcSelectionne: $parcSelectionne,
                infraSelectionnee: $infraSelectionnee,
                aInteragiAvecCarte: $aInteragiAvecCarte,
                deselectionnerAnnotation: $deselectionnerAnnotation
            )
            .sheet(item: $infraSelectionnee, onDismiss: {
                deselectionnerAnnotation = true
                infraSelectionnee = nil
                
            }) { infra in
                sheetVue(infra: infra)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .edgesIgnoringSafeArea(.all)
            
            Button  {
                parcSelectionne = nil
                infraSelectionnee = nil
                demandeRecentrage = true
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
                    self.location = nouvellePosition
                    if !aInteragiAvecCarte {
                        self.centrageInitial = true
                        self.aCentreSurUtilisateur = true
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
