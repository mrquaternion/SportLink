//
//  ActiviteRangeeVue.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-02.
//

import SwiftUI
import MapKit

struct RangeeActivite: View {
    @EnvironmentObject private var emplacementsVM: DonneesEmplacementService
    @State private var estFavoris = false
    @Binding var estSelectionnee: Bool

    let activite: Activite
    let geolocalisation: CLLocationCoordinate2D?
    private let vm = ExplorerListeVM()

    // Distance en kilomètres, ou nil si la géoloc n'est pas fournie
    private var distanceStr: String {
        guard
            let userLoc = geolocalisation,
            let infraCoords = vm.obtenirInfrastructureObj(
                pour: activite.infraId,
                service: emplacementsVM
            )?.coordonnees
        else {
            return ""
        }
        
        let dist = calculerDistanceEntreCoordonnees(
                position1: userLoc,
                position2: infraCoords
            )
        
        return String(format: "%.2f km away", dist)
    }
    
    private var nomParc: String {
        guard let nom = vm.obtenirParcObjAPartirInfra(pour: activite.infraId, service: emplacementsVM)?.nom
        else { return "" }
        return nom
    }
    
    var body: some View {
        Button {
            estSelectionnee.toggle()
        } label: {
            HStack(spacing: 12) {
                Text(Sport.depuisNom(activite.sport).emoji)
                    .font(.system(size: 35))
                
                VStack(spacing: 2) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(activite.sport.capitalized)
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                            
                            Text(nomParc)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .font(.caption2)
                        }
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.linear(duration: 0.2)) {
                                estFavoris.toggle()
                            }
                        } label: {
                            Image(systemName: estFavoris ? "bookmark" : "bookmark.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 26)
                                .scaleEffect(x: 1.2, y: 1.0)
                                .foregroundStyle(.yellow)
                            
                        }
                    }
                  
                    HStack(alignment: .top) {
                        Text(distanceStr)
                            .italic()
                            .font(.caption2)
                        
                        Spacer()
                        
                        Text(activite.date.affichage)
                            .font(.system(size: 11))
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding(.horizontal, 20)
            .frame(width: 360, height: 80)
            .overlay(
                RoundedRectangle(cornerRadius: 13.52371)
                    .stroke(Color(red: 0.89, green: 0.89, blue: 0.89), lineWidth: 0.7)
            )
            .foregroundStyle(.black)
        }
    }
}

#Preview {
    let mockUtilisateur1 = Utilisateur(
        nomUtilisateur: "mathias13",
        courriel: "",
        photoProfil: "",
        disponibilites: [:],
        sportsFavoris: [],
        activitesFavoris: [],
        partenairesRecents: []
    )
    
    let mockUtilisateur2 = Utilisateur(
        nomUtilisateur: "michel02",
        courriel: "",
        photoProfil: "",
        disponibilites: [:],
        sportsFavoris: [],
        activitesFavoris: [],
        partenairesRecents: []
    )
    
    let mockActivite = Activite(
        titre: "Soccer for amateurs",
        organisateurId: UtilisateurID(valeur: "mockID"),
        infraId: "081-0090",
        sport: .soccer,
        date: DateInterval(start: .now, duration: 3600),
        nbJoueursRecherches: 4,
        participants: [],
        description: "",
        statut: .ouvert,
        invitationsOuvertes: true,
        messages: []
    )
    
    RangeeActivite(estSelectionnee: .constant(false), activite: mockActivite, geolocalisation: CLLocationCoordinate2D(latitude: 45.508888, longitude: -73.561668))
        .environmentObject(DonneesEmplacementService())
}
