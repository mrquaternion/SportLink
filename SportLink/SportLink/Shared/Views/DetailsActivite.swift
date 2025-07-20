//
//  DetailsActivite.swift
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
    @Binding var activite: Activite

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
        return diff == 0 ? "No spot left" : "\(diff) spots left"
    }

    private var nomDuParc: String {
        let (_, parcOpt) = activitesVM.obtenirInfraEtParc(infraId: activite.infraId)
        return parcOpt?.nom ?? ""
    }

    private var infra: Infrastructure? {
        let (infraOpt, _) = activitesVM.obtenirInfraEtParc(infraId: activite.infraId)
        return infraOpt
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left.circle.fill")
                        .font(.title3)
                        .foregroundColor(Color("CouleurParDefaut"))
                        .padding(3)
                        .background(.thinMaterial, in: Circle())
                }

                Spacer()

                Button(action: { afficherVueEdition = true }) {
                    Image(systemName: "square.and.pencil")
                        .font(.title2)
                        .padding()
                }
                .sheet(isPresented: $afficherVueEdition) {
                    ModifierVue(activite: $activite)
                        .environmentObject(activitesVM)
                        .environmentObject(vm)
                }
            }

            ScrollView {
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
                        Text("\(formatTemps.string(from: activite.date.debut)) - \(formatTemps.string(from: activite.date.fin))")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal)

                    // Carte et lieu
                    if let infra = infra {
                        Text(nomDuParc)
                            .font(.title3)
                            .padding(.horizontal)
                            .padding(.bottom, -12)

                        CarteParcSeeMore(infrastructure: infra)
                            .frame(height: 300)
                            .cornerRadius(12)
                            .padding(.horizontal)

                        BoutonOuvrirDansPlans(coordonnees: infra.coordonnees)
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

            Spacer()
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

// ➕ Pour rendre la première lettre majuscule
extension String {
    func capitalized() -> String {
        prefix(1).uppercased() + dropFirst()
    }
}
