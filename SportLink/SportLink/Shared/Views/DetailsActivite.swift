//
//  ActiviteDetails.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-14.
//

import SwiftUI

struct DetailsActivite: View {
    
    @EnvironmentObject var activitesVM: ActivitesVM
    @EnvironmentObject var vm: ActivitesOrganiseesVM
    @Environment(\.dismiss) private var dismiss
    @State private var afficherVueEdition = false
    
    let activite: Activite

    
    private var formatDate: DateFormatter {
        let f = DateFormatter()
        f.locale = Locale(identifier: "fr_CA")
        f.dateStyle = .full
        f.timeStyle = .none
        return f
    }

    private var formatTemps: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }
    
    private var nbPlacesRestantes: String {
        let diff = activite.nbJoueursRecherches - activite.participants.count
        
        if diff == 0 { return "No spot left" }
        return String(format: "%d spots left", diff)
    }
    
    private var nomDuParc: String {
        let (_, parcOpt) = activitesVM.obtenirInfraEtParc(infraId: activite.infraId)
        guard let parc = parcOpt else { return "" }
        
        return parc.nom!
    }
    
    private var infra: Infrastructure? {
        let (infraOpt, _) = activitesVM.obtenirInfraEtParc(infraId: activite.infraId)
        guard let infra = infraOpt else { return nil }
        
        return infra
    }
    
    var body: some View {
        contenu
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left.circle.fill")
                            .font(.title3)
                            .foregroundColor(Color("CouleurParDefaut"))
                            .padding(3)
                            .background(.thinMaterial, in: Circle())
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("\(activite.sport.capitalized) activity")
                        .font(.headline)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        afficherVueEdition = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .font(.title2)
                            .padding()
                    }
                    .sheet(isPresented: $afficherVueEdition) {
                        ModifierVue(activite: activite)
                            .environmentObject(activitesVM)
                            .environmentObject(vm)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
    }
    
    private var contenu: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Titre
            Text(activite.titre)
                .font(.title)
                .bold()
                .padding(.horizontal)

            // Sport
            HStack(spacing: 8) {
                Image(systemName: Sport.depuisNom(activite.sport).icone)
                    .foregroundColor(.red)
                    .font(.title2)

                Text(Sport.depuisNom(activite.sport).nom.capitalized)
                    .font(.title2)
                    .fontWeight(.medium)
            }
            .padding(.horizontal)
            .padding(.top, 4)

            // Date
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .foregroundColor(Color("CouleurParDefaut"))
                    .font(.title3)
                Text("\(formatDate.string(from: activite.date.debut).capitalized)")
                    .font(.title3)
                    .foregroundColor(.black)
            }
            .padding(.horizontal)

            // Heure
            HStack(spacing: 8) {
                Image(systemName: "clock")
                    .foregroundColor(Color("CouleurParDefaut"))
                    .font(.title3)

                Text("\(formatTemps.string(from: activite.date.debut)) - \(formatTemps.string(from: activite.date.debut))")
                    .font(.title3)
                    .foregroundColor(.black)
            }
            .padding(.horizontal)

            // ➤ Bloc sans espacement vertical entre ses éléments
            Group {
                Text(nomDuParc)
                    .font(.title3)
                    .padding(.horizontal)
                    .padding(.bottom, -12)
                    
                CarteParcSeeMore(infrastructure: infra!)
                    .frame(height: 300)
                    .cornerRadius(12)
                    .padding(.horizontal)

                BoutonOuvrirDansPlans(coordonnees: infra!.coordonnees)
            }

            // Places disponibles
            HStack(spacing: 8) {
                Image(systemName: "person.2")
                    .foregroundColor(Color("CouleurParDefaut"))
                    .font(.headline)
                Text("Places disponibles : \(nbPlacesRestantes)")
                    .foregroundColor(.black)
                    .font(.title3)
            }
            .padding(.horizontal)
            .padding(.top, 4)

            // Invitations invité.e.s
            HStack(spacing: 8) {
                Image(systemName: activite.invitationsOuvertes ? "envelope.open" : "figure.child.and.lock.fill")
                    .foregroundColor(Color("CouleurParDefaut"))

                Text(activite.invitationsOuvertes ? "Open to guests invitations" : "Close to guests invitations")
                    .foregroundColor(.black)
            }
            .font(.title3)
            .padding(.horizontal)
        }
    }
    
}


#Preview {
    let mockActivite = Activite(
        titre: "Match amical",
        organisateurId: UtilisateurID(valeur: "demo"),
        infraId: "081-0090",
        sport: .soccer,
        date: DateInterval(start: .now, duration: 3600),
        nbJoueursRecherches: 6,
        participants: [],
        description: "Venez vous amuser !",
        statut: .ouvert,
        invitationsOuvertes: true,
        messages: []
    )

    let serviceEmplacements = DonneesEmplacementService()

    DetailsActivite(activite: mockActivite)
        .environmentObject(ActivitesOrganiseesVM(
            serviceActivites: ServiceActivites(),
            serviceEmplacements: serviceEmplacements
        ))
        .environmentObject(
            ActivitesVM(serviceEmplacements: serviceEmplacements)
        )
}
