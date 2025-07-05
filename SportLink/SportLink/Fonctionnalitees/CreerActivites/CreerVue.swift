//
//  CreerActivitesVue.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-06-21.
//

import SwiftUI
import CoreLocation

private enum ActiveOverlay {
    case none, sport, date, time, participants, guests
}

struct CreerVue: View {
    @EnvironmentObject var emplacementsVM: DonneesEmplacementService
    @EnvironmentObject var serviceActivites: ServiceFuncActivites
    @Environment(\.dismiss) var dismiss
    
    @State private var sportSelectionne: Sport = .soccer
    @State private var dateSelectionnee: Date = .init()
    @State private var tempsDebut: Date = .init()
    @State private var tempsFin: Date = Calendar.current.date(byAdding: .hour, value: 1, to: .init())!
    @State private var nbParticipants: Int?
    @State private var permettreInvitations: Bool?
    @State private var overlayActif: ActiveOverlay = .none
    @State private var sportChoisis: Set<String> = [Sport.soccer.nom.capitalized]
    @State private var infraChoisie: Infrastructure? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer().frame(height: 8)
                OverlayOptionButton(
                    icon: sportSelectionne.icone,
                    text: sportSelectionne.nom.capitalized,
                    action: { overlayActif = .sport }
                )
                OverlayOptionButton(
                    icon: "calendar",
                    text: dateString,
                    action: { overlayActif = .date }
                )
                OverlayOptionButton(
                    icon: "clock",
                    text: "\(startTimeString) to \(endTimeString)",
                    action: { overlayActif = .time }
                )
                    
                VStack(spacing: 8) {
                    MiniCarteBouton(sportChoisis: $sportChoisis, infraChoisie: $infraChoisie)
                        .padding(.horizontal)
                        .environmentObject(emplacementsVM)
                    
                    Text((infraChoisie != nil) ? "A marker has been selected" : "Click on the map to select a marker")
                        .font(.caption)
                        .foregroundStyle(Color(red: 0.3, green: 0.3, blue: 0.3))
                        
                }
                
                OverlayOptionButton(
                    icon: "person.3",
                    text: participantsText,
                    action: { overlayActif = .participants }
                )
                OverlayOptionButton(
                    icon: "person.2.badge.plus",
                    text: guestsText,
                    action: { overlayActif = .guests }
                )
                HStack {
                    Spacer()
                    Button("Invite teammates") { /* à compléter */ }
                        .buttonStyle(.bordered)
                        .tint(.red)
                    Spacer()
                }.padding(.horizontal)
                Spacer()
                
                // MARK: Bouton de création de l'activité
                Button {
                    guard let infra = infraChoisie else {
                        print("Aucune infrastructure sélectionnée.")
                        return
                    }
                    
                    guard let nb = nbParticipants, let autoriserInvitations = permettreInvitations else {
                        print("Veuillez sélectionner tous les champs nécessaires.")
                        return
                    }

                    // Créer l'intervalle de date
                    let calendrier = Calendar.current
                    let dateDebut = calendrier.date(bySettingHour: calendrier.component(.hour, from: tempsDebut),
                                                    minute: calendrier.component(.minute, from: tempsDebut),
                                                    second: 0,
                                                    of: dateSelectionnee) ?? dateSelectionnee

                    let dateFin = calendrier.date(bySettingHour: calendrier.component(.hour, from: tempsFin),
                                                  minute: calendrier.component(.minute, from: tempsFin),
                                                  second: 0,
                                                  of: dateSelectionnee) ?? dateDebut.addingTimeInterval(3600)

                    let interval = DateInterval(start: dateDebut, end: dateFin)

                    // Créer l’activité
                    do {
                        let activite = try Activite(
                            titre: "Activité \(sportSelectionne.nom)", // ou demander à l'utilisateur d'écrire un titre
                            organisateurId: UtilisateurID(valeur: "mockID"), // remplace par le bon ID utilisateur
                            infraId: infra.id,
                            sport: sportSelectionne,
                            date: interval,
                            nbJoueursRecherches: nb,
                            participants: [],
                            statut: .ouvert,
                            invitationsOuvertes: autoriserInvitations,
                            messages: []
                        )

                        Task {
                            await serviceActivites.sauvegarderActiviteAsync(activite: activite)
                            dismiss()
                        }
                    } catch {
                        print("Erreur lors de la création de l'activité : \(error)")
                    }
                } label: {
                    Text("Create")
                        .font(.title3)
                        .fontWeight(.medium)
                        .padding(.horizontal, 20)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
            .padding(.horizontal)
            .padding(.vertical, 60)
            .navigationTitle("Create an activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
            .onChange(of: tempsDebut) { _, new in
                if tempsFin < new {
                    tempsFin = Calendar.current.date(byAdding: .hour, value: 1, to: new)!
                }
            }
            .overlay(overlayView)
        }
    }

    @ViewBuilder
    private var overlayView: some View {
        switch overlayActif {
        case .sport: sportPicker
        case .date: datePicker
        case .time: timePicker
        case .participants: participantsPicker
        case .guests: guestsPicker
        default: EmptyView()
        }
    }

    private var sportPicker: some View {
        CustomOverlay(isPresented: Binding(
            get: { overlayActif == .sport },
            set: { if !$0 { overlayActif = .none } }
        )) {
            VStack(spacing: 16) {
                Text("Select a sport").font(.headline)
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(Sport.allCases, id: \.self) { sport in
                            Button {
                                sportChoisis = [sport.nom.capitalized]
                                sportSelectionne = sport
                                overlayActif = .none
                            } label: {
                                HStack {
                                    Image(systemName: sport.icone)
                                        .foregroundColor(.red)
                                    Text(sport.nom.capitalized)
                                        .foregroundColor(.red)
                                    Spacer()
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
                Button("Confirm") { overlayActif = .none }
            }.padding()
        }
    }

    private var datePicker: some View {
        CustomOverlay(isPresented: Binding(
            get: { overlayActif == .date },
            set: { if !$0 { overlayActif = .none } }
        )) {
            VStack(spacing: 16) {
                Text("Select a date").font(.headline)
                DatePicker("", selection: $dateSelectionnee, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .frame(maxHeight: 300)
                Button("Confirm") { overlayActif = .none }
            }.padding()
        }
    }

    private var timePicker: some View {
        CustomOverlay(isPresented: Binding(
            get: { overlayActif == .time },
            set: { if !$0 { overlayActif = .none } }
        )) {
            VStack(spacing: 20) {
                Text("Select the time").font(.headline)

                VStack(alignment: .trailing, spacing: 16) {
                    HStack(spacing: 12) {
                        Text("Start:")
                        DatePicker("", selection: $tempsDebut, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.compact).labelsHidden().tint(.red)
                        Image(systemName: "clock").foregroundColor(.red)
                    }
                    HStack(spacing: 12) {
                        Text("End:")
                        DatePicker("", selection: $tempsFin, in: tempsDebut..., displayedComponents: .hourAndMinute)
                            .datePickerStyle(.compact).labelsHidden().tint(.red)
                        Image(systemName: "clock").foregroundColor(.red)
                    }
                }
                
                Button("Confirm") { overlayActif = .none }
            }
            .padding().frame(maxWidth: 300)
        }
    }

    private var participantsPicker: some View {
        CustomOverlay(isPresented: Binding(
            get: { overlayActif == .participants },
            set: { if !$0 { overlayActif = .none } }
        )) {
            VStack(spacing: 16) {
                Text("Select the number").font(.headline)
                Picker("", selection: Binding(get: { nbParticipants ?? 0 }, set: { nbParticipants = $0 })) {
                    ForEach(0..<16, id: \.self) { Text("\($0)") }
                }
                .pickerStyle(.wheel).frame(height: 150).clipped()
                Button("Confirm") { overlayActif = .none }
            }.padding().frame(maxWidth: 300)
        }
    }

    private var guestsPicker: some View {
        CustomOverlay(isPresented: Binding(
            get: { overlayActif == .guests },
            set: { if !$0 { overlayActif = .none } }
        )) {
            VStack(spacing: 16) {
                Text("Participants : invitations") .font(.headline)
                Button {
                    permettreInvitations = true; overlayActif = .none
                } label: { Label("Authorize", systemImage: "figure.child.and.lock.open.fill")
                        .frame(maxWidth: .infinity).padding().background(Color(.systemGray6)).cornerRadius(8)
                }.buttonStyle(.plain)
                Button {
                    permettreInvitations = false; overlayActif = .none
                } label: { Label("Disallow", systemImage: "figure.child.and.lock.fill")
                        .frame(maxWidth: .infinity).padding().background(Color(.systemGray6)).cornerRadius(8)
                }.buttonStyle(.plain)
                Button("Close") { overlayActif = .none }
            }.padding().frame(maxWidth: 300)
        }
    }

    // MARK: - Helpers

    private var dateString: String {
        let f = DateFormatter(); f.dateStyle = .medium; return f.string(from: dateSelectionnee)
    }
    private var startTimeString: String {
        let f = DateFormatter(); f.timeStyle = .short; return f.string(from: tempsDebut)
    }
    private var endTimeString: String {
        let f = DateFormatter(); f.timeStyle = .short; return f.string(from: tempsFin)
    }
    private var participantsText: String {
        if let c = nbParticipants { return "\(c) participant\(c>1 ? "s" : "")" }
        else { return "Number of participants" }
    }
    private var guestsText: String {
        if let a = permettreInvitations {
            return a ? "I authorize guests invitations" : "I do not authorize guests invitations"
        }
        else { return "Authorize guests invitations" }
    }
}

struct OverlayOptionButton: View {
    let icon: String, text: String, action: () -> Void
    var body: some View {
        Button(action: action) {
            RectangleVue(showChevron: true) {
                Image(systemName: icon).resizable().scaledToFit()
                    .frame(width: 20, height: 20).foregroundColor(.red)
                Text(text).foregroundColor(.black)
            }
        }.buttonStyle(.plain)
    }
}

#Preview {
    CreerVue()
        .environmentObject(DonneesEmplacementService())
        .environmentObject(ServiceFuncActivites())
}

