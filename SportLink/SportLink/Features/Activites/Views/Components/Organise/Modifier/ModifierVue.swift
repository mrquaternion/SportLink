//
//  ModifierVue.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-17.
//

// NouvelleVueEdition.swift

import SwiftUI
import MapKit

struct ModifierVue: View {
    @FocusState private var titreEstEnEdition: Bool
    
    @EnvironmentObject var vm: ActivitesOrganiseesVM
    @EnvironmentObject var activitesVM: ActivitesVM
    @Environment(\.dismiss) var dismiss

    let activite: Activite
    
    @State private var titre: String = ""
    @State private var nombreParticipants: Int = 4
    @State private var invitationsOuvertes: Bool = true
    @State private var afficherSelectionParticipants = false
    @State private var afficherModaleInvitations = false

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
        return parcOpt?.nom ?? ""
    }

    private var infra: Infrastructure? {
        let (infraOpt, _) = activitesVM.obtenirInfraEtParc(infraId: activite.infraId)
        return infraOpt
    }
    
    var champTitre: some View {
        TextField("Nom de l'activité", text: $titre)
            .focused($titreEstEnEdition)
            .submitLabel(.done)
            .onSubmit {
                titreEstEnEdition = false
                vm.serviceActivites.recupererIdActiviteParInfraId(activite.infraId) { idRecupere, erreur in
                    guard erreur == nil, let id = idRecupere else { return }
                    
                    vm.serviceActivites.modifierTitreActivite(idActivite: id, nouveauTitre: titre) { error in
                        guard error == nil else { return }
                        vm.mettreAJourTitreLocalement(idActivite: id, nouveauTitre: titre)
                    }
                }
            }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .padding()
                .foregroundColor(.blue)
                .font(.headline)
                
                Spacer()
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Champ titre modifiable stylisé
                    HStack {
                        champTitre
                            .font(.title3)
                            .foregroundColor(.black)
                            .padding(.leading)
                            .disabled(false)

                        Image(systemName: "pencil")
                            .foregroundColor(.gray)
                            .padding(.trailing)
                    }
                    .frame(height: 50)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .contentShape(Rectangle()) // Rend tout le HStack cliquable
                    .onTapGesture {
                        titreEstEnEdition = true
                    }
                    .padding(.horizontal)
                    .padding(.top, 4)
                    
                    
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
                    
                    HStack(spacing: 8) {
                        Image(systemName: "calendar")
                            .foregroundColor(Color("CouleurParDefaut"))
                            .font(.title3)
                        Text("\(dateFormatter.string(from: activite.date.debut).capitalized)")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal)
                    
                    HStack(spacing: 8) {
                        Image(systemName: "clock")
                            .foregroundColor(Color("CouleurParDefaut"))
                            .font(.title3)
                        
                        Text("\(formatter.string(from: activite.date.debut)) - \(formatter.string(from: activite.date.debut))")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal)
                    
                    Group {
                        Text(nomDuParc)
                            .font(.title3)
                            .padding(.horizontal)
                            .padding(.bottom, -12)
                        
                        if let infra = infra {
                            CarteParcSeeMore(infrastructure: infra)
                                .frame(height: 300)
                                .cornerRadius(12)
                                .padding(.horizontal)
                        }
                    }
                    
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        
        .onAppear {
            titre = activite.titre
        }
        
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
