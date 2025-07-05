//
//  sheetVue.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-25.
//

import SwiftUI
import MapKit

struct InfraDetailVue: View {
    @EnvironmentObject var serviceActivites: ServiceFuncActivites
    @State var estEnChargement: Bool = true
    @Binding var utilisateur: Utilisateur
    
    var infra: Infrastructure
    var parcParent: Parc
    @Binding var dateSelectionnee: Date
    
    init(infra: Infrastructure, parc: Parc, dateSelectionnee: Binding<Date>, utilisateur: Binding<Utilisateur>) {
        self.infra = infra
        self.parcParent = parc
        self._dateSelectionnee = dateSelectionnee
        self._utilisateur = utilisateur
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                sectionEntete
                
                sectionActivites
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 30)
        }
        .background(Color(.systemGroupedBackground))
        .onAppear {
            Task {
                estEnChargement = true
                await serviceActivites.fetchActivitesParInfrastructureEtDateAsync(infraId: infra.id, date: dateSelectionnee)
                estEnChargement = false
            }
        }
    }
    
    // MARK: - Details Section
    private var sectionEntete: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Infrastructure Details")
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                RecherchePOIVue(parc: parcParent)
                    .scaleEffect(0.8, anchor: .trailing)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                // Sport type
                detailsRangee(icon: "sportscourt", title: "Sport Type", value: infra.sport[0].rawValue.capitalized)
                
                // Location
                detailsRangee(icon: "mappin.circle.fill", title: "Location", value: parcParent.nom ?? "Unknown", iconColor: .red)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
    
    private var sectionActivites: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Organized activities")
                    .font(.headline)
                
                Spacer()
            }
            
            if estEnChargement {
                ProgressView()
            } else if serviceActivites.activites.isEmpty {
                Text("No activity has been organized.")
            } else {
                ForEach(serviceActivites.activites, id: \.id) { activite in
                    let (heureDebut, heureFin) = activite.obtenirPlageHoraireStr()
                    
                    HStack(alignment: .center, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(activite.titre)
                                .font(.headline)
                                .foregroundColor(.primary)

                            Text("\(heureDebut) - \(heureFin)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        Spacer()
                    }
                    .frame(height: 30)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                    )
                }

            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
    
    // MARK: - Helper Views
    private func detailsRangee(icon: String, title: String, value: String, iconColor: Color = .blue) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(iconColor)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(value)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
            }
            
            Spacer()
        }
    }
    
}

#Preview {
    // Create mock data for preview
    let mockInfra = Infrastructure(
        id: "1",
        indexParc: "2",
        coordonnees: CLLocationCoordinate2D(latitude: 2, longitude: 2),
        sport: [.soccer]
    )
    let mockParc = Parc(
        index: "2",
        nom: "Central Park",
        limites: [CLLocationCoordinate2D(latitude: 2, longitude: 2)],
        idsInfra: ["1"]
    )
    let mockUtilisateur = Utilisateur(
        nomUtilisateur: "mathias13",
        courriel: "",
        photoProfil: "",
        disponibilites: [:],
        sportsFavoris: [],
        activitesFavoris: [],
        partenairesRecents: []
    )
    
    InfraDetailVue(
        infra: mockInfra,
        parc: mockParc,
        dateSelectionnee: .constant(Date()),
        utilisateur: .constant(mockUtilisateur)
    )
    .environmentObject(ServiceFuncActivites())
}
