//
//  SeeMoreVueHosted.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-15.
//


import SwiftUI
import MapKit

struct SeeMoreVueHosted: View {
    @EnvironmentObject var vm: ActivitesOrganiseesVM
    @EnvironmentObject var activitesVM: ActivitesVM
    @Environment(\.dismiss) var dismiss
    @State private var afficherVueEdition = false

    let activite: Activite

    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.locale = Locale(identifier: "fr_CA")
        f.dateStyle = .full
        f.timeStyle = .none
        return f
    }

    private var formatter: DateFormatter {
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
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                }

                Spacer()

                Button(action: {
                    afficherVueEdition = true
                }) {
                    Image(systemName: "square.and.pencil")
                        .font(.title2)
                        .padding()
                }
                .sheet(isPresented: $afficherVueEdition) {
                    ModifierVue()
                }
            }

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
                    Text("\(dateFormatter.string(from: activite.date.debut).capitalizedFirstLetter())")
                        .font(.title3)
                        .foregroundColor(.black)
                }
                .padding(.horizontal)

                // Heure
                HStack(spacing: 8) {
                    Image(systemName: "clock")
                        .foregroundColor(Color("CouleurParDefaut"))
                        .font(.title3)

                    Text("\(formatter.string(from: activite.date.debut)) - \(formatter.string(from: activite.date.debut))")
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

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

// La première lettre du jour est en Majuscule
extension String {
    func capitalizedFirstLetter() -> String {
        prefix(1).uppercased() + dropFirst()
    }
}

#Preview {
    let mockActivite =
    Activite(
        titre: "Soccer for amateurs",
        organisateurId: UtilisateurID(valeur: "demo"),
        infraId: "081-0090",
        sport: .soccer,
        date: DateInterval(start: .now, duration: 3600),
        nbJoueursRecherches: 4,
        participants: [],
        description: "Venez vous amuser !",
        statut: .ouvert,
        invitationsOuvertes: true,
        messages: []
    )
    
    SeeMoreVueHosted(activite: mockActivite)
        .environmentObject(ActivitesOrganiseesVM(serviceActivites: ServiceActivites(), serviceEmplacements: DonneesEmplacementService()))
}
