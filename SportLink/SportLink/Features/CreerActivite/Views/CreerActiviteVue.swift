//
//  CreerActivitesVue.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-06-21.
//

import SwiftUI
import CoreLocation
import Combine

enum ActiveOverlay {
    case none, sport, date, temps, participants, invites
}

struct CreerActiviteVue: View {
    @EnvironmentObject var emplacementsVM: DonneesEmplacementService
    @Environment(\.dismiss) var dismiss
    @StateObject var vm = CreerActiviteVM()
    @State private var titre: String = ""
    @State private var sportSelectionne: Sport = .soccer
    @State private var dateSelectionnee: Date = .init()
    @State private var tempsDebut: Date = .init()
    @State private var tempsFin: Date = Calendar.current.date(byAdding: .hour, value: 1, to: .init())!
    @State private var nbParticipants: Int?
    @State private var permettreInvitations: Bool?
    @State private var overlayActif: ActiveOverlay = .none
    @State private var sportChoisis: Set<String> = [Sport.soccer.nom.capitalized]
    @State private var infraChoisie: Infrastructure? = nil
    private let dateMin = Date.now
    private let dateMax = Calendar.current.date(byAdding: .weekOfYear, value: 4, to: Date())!
    private let texteLimite = 40

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    ChampTitre(
                        titre: $titre,
                        overlayActif: $overlayActif,
                        texteLimite: texteLimite
                    )
                    
                    BoutonOptionOverlay(
                        icon: sportSelectionne.icone,
                        text: sportSelectionne.nom.capitalized,
                        action: { overlayActif = .sport }
                    )
                    BoutonOptionOverlay(
                        icon: "calendar",
                        text: dateEnString,
                        action: { overlayActif = .date }
                    )
                    BoutonOptionOverlay(
                        icon: "clock",
                        text: "\(debutDuTempsEnString) to \(finDuTempsEnString)",
                        action: { overlayActif = .temps }
                    )
                    
                    VStack(spacing: 8) {
                        BoutonAvecApercuCarte(sportChoisis: $sportChoisis, infraChoisie: $infraChoisie)
                            .padding(.horizontal)
                            .environmentObject(emplacementsVM)
                        
                        Text((infraChoisie != nil) ? "A marker has been selected" : "Click on the map to select a marker")
                            .font(.caption)
                            .foregroundStyle(Color(red: 0.3, green: 0.3, blue: 0.3))
                        
                    }
                    
                    BoutonOptionOverlay(
                        icon: "person.3",
                        text: texteParticipants,
                        action: { overlayActif = .participants }
                    )
                    BoutonOptionOverlay(
                        icon: "person.2.badge.plus",
                        text: texteInvitations,
                        action: { overlayActif = .invites }
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
                        Task {
                            await vm.creerActivite(
                                nbParticipants: nbParticipants,
                                permettreInvitations: permettreInvitations,
                                tempsDebut: tempsDebut,
                                tempsFin: tempsFin,
                                dateSelectionnee: dateSelectionnee,
                                titre: titre,
                                sportSelectionne: sportSelectionne
                            )
                            dismiss()
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
                .padding(.top, 40)
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
                .overlay(vueOverlay)
            }
        }
    }

    @ViewBuilder
    private var vueOverlay: some View {
        switch overlayActif {
        case .sport: pickerPourSport
        case .date: pickerPourDate
        case .temps: pickerPourHeure
        case .participants: pickerPourParticipants
        case .invites: pickerPourInvites
        default: EmptyView()
        }
    }

    private var pickerPourSport: some View {
        FenetreModaleFlottante(isPresented: Binding(
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

    private var pickerPourDate: some View {
        FenetreModaleFlottante(isPresented: Binding(
            get: { overlayActif == .date },
            set: { if !$0 { overlayActif = .none } }
        )) {
            VStack(spacing: 16) {
                Text("Select a date").font(.headline)
                DatePicker("", selection: $dateSelectionnee, in: dateMin...dateMax,displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .frame(maxHeight: 300)
                Button("Confirm") { overlayActif = .none }
            }.padding()
        }
    }

    private var pickerPourHeure: some View {
        FenetreModaleFlottante(isPresented: Binding(
            get: { overlayActif == .temps },
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

    private var pickerPourParticipants: some View {
        FenetreModaleFlottante(isPresented: Binding(
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

    private var pickerPourInvites: some View {
        FenetreModaleFlottante(isPresented: Binding(
            get: { overlayActif == .invites },
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
    private var dateEnString: String {
        let f = DateFormatter(); f.dateStyle = .medium; return f.string(from: dateSelectionnee)
    }
    private var debutDuTempsEnString: String {
        let f = DateFormatter(); f.timeStyle = .short; return f.string(from: tempsDebut)
    }
    private var finDuTempsEnString: String {
        let f = DateFormatter(); f.timeStyle = .short; return f.string(from: tempsFin)
    }
    private var texteParticipants: String {
        if let c = nbParticipants { return "\(c) participant\(c>1 ? "s" : "")" }
        else { return "Number of participants" }
    }
    private var texteInvitations: String {
        if let a = permettreInvitations {
            return a ? "I authorize guests invitations" : "I disallow guests invitations"
        }
        else { return "Authorize guests invitations" }
    }
}

struct BoutonOptionOverlay: View {
    let icon: String, text: String, action: () -> Void
    var body: some View {
        Button(action: action) {
            BoiteAvecChevron(showChevron: true) {
                Image(systemName: icon).resizable().scaledToFit()
                    .frame(width: 20, height: 20).foregroundColor(.red)
                Text(text).foregroundColor(.black)
            }
        }.buttonStyle(.plain)
    }
}

struct ChampTitre: View {
    @Binding var titre: String
    @Binding var overlayActif: ActiveOverlay
    let texteLimite: Int
    
    var body: some View {
        HStack {
            TextField("Title of the activity", text: $titre)
                .onReceive(Just(titre)) { _ in limiterTexte(texteLimite) }
                .disabled(overlayActif != .none)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 50)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.gray.opacity(0.1), radius: 2, x: 0, y: 1)
        )
        .padding(.horizontal)
    }
    
    func limiterTexte(_ upper: Int) {
        if titre.count > upper {
            titre = String(titre.prefix(upper))
        }
    }
}

#Preview {
    CreerActiviteVue()
        .environmentObject(DonneesEmplacementService())
}

