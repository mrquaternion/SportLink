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
    @EnvironmentObject var emplacementsVM: DonneesEmplacementService
    @EnvironmentObject var serviceActivites: ServiceFuncActivites
    
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
    @State private var typeDeCarteSelectionne: TypeDeCarte = .standard
    @State private var filtresSelectionnes: Set<String> = ["All"]
    
    @State private var dateSelectionnee: Date = Date.now
    @State var afficherTypeDeCarte = false
    
    @Binding var utilisateur: Utilisateur
    
    private let couleurDeFond = Color(red: 0.97, green: 0.97, blue: 0.97)
    
    var body: some View {
        // Carte
        ZStack {
            CarteVue(
                parcs: emplacementsVM.parcs,
                infras: emplacementsVM.infrastructures,
                localisationUtilisateur: location,
                centrageInitial: $centrageInitial,
                demandeRecentrage: $demandeRecentrage,
                parcSelectionne: $parcSelectionne,
                infraSelectionnee: $infraSelectionnee,
                aInteragiAvecCarte: $aInteragiAvecCarte,
                deselectionnerAnnotation: $deselectionnerAnnotation,
                typeDeCarteSelectionne: $typeDeCarteSelectionne,
                filtresSelectionnes: $filtresSelectionnes
            )
            .sheet(item: $infraSelectionnee, onDismiss: {
                deselectionnerAnnotation = true
                infraSelectionnee = nil
            }) { infra in
                let parcParent = emplacementsVM.parcs.filter { $0.index == infra.indexParc }
                
                InfraDetailVue(infra: infra, parc: parcParent.first!, dateSelectionnee: $dateSelectionnee, utilisateur: $utilisateur)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
                    .environmentObject(serviceActivites)
            }
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                BarreTemporelleVue(dateSelectionnee: $dateSelectionnee)
                    .padding(.horizontal, 14)
                    .frame(width: 380, height: 125, alignment: .center)
                    .background(couleurDeFond)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 2)
                
                FiltreCarteVue(filtresSelectionnes: $filtresSelectionnes)
                
                Spacer()
            }
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    // MARK: Bouton pour changer les types de carte
                    Button {
                        afficherTypeDeCarte = true
                    } label: {
                        Image(systemName: "square.2.layers.3d")
                            .font(.title2)
                            .padding(10)
                            .background(couleurDeFond)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.4), radius: 1.5, x: 0, y: 1)
                    }
                    .buttonStyle(.plain)
                    .padding([.top, .leading, .trailing])
                    .padding(.bottom, -10)
                    .sheet(isPresented: $afficherTypeDeCarte) {
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    afficherTypeDeCarte = false
                                }) {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 17, height: 17)
                                        .font(.title)
                                        .foregroundColor(.gray)
                                }
                                .padding([.leading, .top])
                                .padding(.trailing, 20)
                            }

                            Spacer()
                            
                            HStack(spacing: 60) {
                                // MARK: Types de carte
                                ForEach(TypeDeCarte.allCases, id: \.self) { type in
                                    Button {
                                        typeDeCarteSelectionne = type
                                    } label: {
                                        VStack {
                                            Image(type.nomLisible)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 60, height: 60)
                                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                                .padding(4)
                                                .overlay( // Ajouter la bordure conditionnelle
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .stroke(type == typeDeCarteSelectionne ? Color("CouleurParDefaut") : Color.clear, lineWidth: 2)
                                                )
                                            
                                            Text(type.nomLisible.capitalized)
                                                .fontWeight(type == typeDeCarteSelectionne ? .medium : .regular)
                                                .foregroundStyle(type == typeDeCarteSelectionne ? Color("CouleurParDefaut") : .black)
                                        }
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            
                            Spacer()
                        }
                        .presentationDetents([.fraction(0.23)])
                        .presentationDragIndicator(.visible)
                    }
                }
                
                HStack {
                    Spacer()
                    
                    // MARK: Bouton de recentrage utilisateur
                    Button  {
                        parcSelectionne = nil
                        infraSelectionnee = nil
                        demandeRecentrage = true
                    } label: {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .padding(10)
                            .background(couleurDeFond)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.4), radius: 1.5, x: 0, y: 1)
                    }
                    .buttonStyle(.plain)
                    .padding([.top, .leading, .trailing])
                    .padding(.bottom, 20)
                }
            }
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
    let mockUtilisateur = Utilisateur(
        nomUtilisateur: "mathias13",
        courriel: "",
        photoProfil: "",
        disponibilites: [:],
        sportsFavoris: [],
        activitesFavoris: [],
        partenairesRecents: []
    )
    
    ExplorerCarteVue(utilisateur: .constant(mockUtilisateur))
        .environmentObject(DonneesEmplacementService())
        .environmentObject(ServiceFuncActivites())
}
