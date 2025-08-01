//
//  ActivitesRecommandees.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-25.
//

import SwiftUI

struct ActivitesRecommandees: View {
    @EnvironmentObject var session: Session
    @StateObject private var vm: ActivitesRecommandeesVM
    
    init(serviceEmplacements: DonneesEmplacementService) {
        self._vm = StateObject(wrappedValue: ActivitesRecommandeesVM(
            serviceActivites: ServiceActivites(),
            serviceEmplacements: serviceEmplacements
        ))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            titre
            VStack {
                ForEach(session.activitesRecommandees, id: \.id) { activite in
                    ActiviteRangee(activite: activite)
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .mask(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.15), radius: 2)
        }
    }
    
    @ViewBuilder
    private var titre: some View {
        HStack {
            Text("recommanded activites".localizedFirstCapitalized)
                .font(.title2.weight(.semibold))
            Spacer()
            Image(systemName: "info.circle")
                .foregroundStyle(.secondary)
                .padding(.top, 3)
                .onTapGesture {
                    // Afficher message info
                }
        }
    }
}

struct ActiviteRangee: View {
    // MARK: Variables et propriétés calculées
    @EnvironmentObject var activitesVM: ActivitesVM
    let activite: Activite
    
    private var nomDuParc: String {
           let (_, parcOpt) = activitesVM.obtenirInfraEtParc(infraId: activite.infraId)
           guard let parc = parcOpt else { return "" }
           
           return parc.nom!
       }
       
       private var composantesDate: String {
           let (date, tempsDebut, tempsFin) = activite.date.affichage
           return "\(date), \(tempsDebut) - \(tempsFin)"
       }
    
    var body: some View {
        HStack(spacing: 12) {
            Text(Sport.depuisNom(activite.sport).emoji)
                .font(.system(size: 35))
                
            VStack(spacing: 2) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(activite.sport.capitalized)
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                        
                        Text(nomDuParc)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .font(.caption2)
                    }
                    
                    Spacer()
                }
                  
                HStack(alignment: .top) {
                    Text(activitesVM.obtenirDistanceDeUtilisateur(pour: activite))
                        .italic()
                        .font(.caption2)
                    
                    Spacer()
                    
                    Text(composantesDate)
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

#Preview {
    ActivitesRecommandees(serviceEmplacements: DonneesEmplacementService())
        .environmentObject(ActivitesVM(serviceEmplacements: DonneesEmplacementService()))
}
