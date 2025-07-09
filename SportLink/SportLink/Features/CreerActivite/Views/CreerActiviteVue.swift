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

struct TripleDates: Equatable {
    let selection: Date
    let debut: Date
    let fin: Date
}

struct CreerActiviteVue: View {
    @EnvironmentObject var emplacementsVM: DonneesEmplacementService
    @Environment(\.dismiss) var dismiss
    @StateObject var vm = CreerActiviteVM()
    @State private var titre: String = ""
    @State private var sportSelectionne: Sport = .soccer
    @State private var sportSelectionTemporaire: Sport? = .soccer
    @State private var dateSelectionnee: Date
    @State private var dateSelectionneeSelectionTemporaire: Date?
    @State private var tempsDebut: Date
    @State private var tempsDebutSelectionTemporaire: Date?
    @State private var tempsFin: Date
    @State private var tempsFinSelectionTemporaire: Date?
    @State private var nbParticipants: Int = 0
    @State private var nbParticipantsSelectionTemporaire: Int? = 0
    @State private var description: String = ""
    @State private var permettreInvitations: Bool = true
    @State private var permettreInvitationsSelectionTemporaire: Bool = true
    @State private var overlayActif: ActiveOverlay = .none
    @State private var sportChoisis: Set<String> = [Sport.soccer.nom.capitalized]
    @State private var infraChoisie: Infrastructure? = nil
<<<<<<< HEAD
    private let dateMin = Date.now
    private let dateMax = Calendar.current.date(byAdding: .weekOfYear, value: 4, to: Date())!
    private let texteLimite = 40
    @State private var description: String = ""

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
                    
                    BoiteDescription(description: $description, nombreMotsMax: 50)


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
=======
    @State private var dateMin: Date
    @State private var dateMax: Date
    private let titreLimite = 40
    private let descriptionLimite = 420
    @State private var montrerAlerteChevauchement = false
    
    init() {
        let maintenant = Date.now
        let calendrier = Calendar.current
        let heureActuelle = calendrier.component(.hour, from: maintenant)
        let valeurDeBase: Date
        
        if heureActuelle >= 22 || heureActuelle < 6 {
            let debutAujourdhui = calendrier.startOfDay(for: maintenant)
            let debutDemain = calendrier.date(
                byAdding: .day,
                value: 1,
                to: debutAujourdhui
            )!
            valeurDeBase = calendrier.date(
                bySettingHour: 6,
                minute: 0,
                second: 0,
                of: debutDemain
            )!
        } else {
            valeurDeBase = maintenant
        }
        _dateSelectionnee = State(initialValue: valeurDeBase)
        _dateSelectionneeSelectionTemporaire = State(initialValue: valeurDeBase)
        _dateMin = State(initialValue: valeurDeBase)
        _tempsDebut = State(initialValue: valeurDeBase)
        _tempsDebutSelectionTemporaire = State(initialValue: valeurDeBase)
        
        let fin = Calendar.current.date(byAdding: .hour, value: 1, to: valeurDeBase)!
        _tempsFin = State(initialValue: fin)
        _tempsFinSelectionTemporaire = State(initialValue: fin)
        
        let max = Calendar.current.date(byAdding: .weekOfYear, value: 4, to: valeurDeBase)!
        _dateMax = State(initialValue: max)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                contenuPrincipal
            }
            .onChange(of: tempsDebut) { _, nv in
                if tempsFin < nv {
                    tempsFin = Calendar.current.date(byAdding: .hour, value: 1, to: nv)!
>>>>>>> e37782140e2d0013f03fcc35eea244aeaa8f2f14
                }
            }
            .toolbar {
                contenuToolbar
            }
            .safeAreaInset(edge: .bottom, alignment: .center) {
                barAction
            }
        }
        .overlay(vueOverlay)
    }
    
    private var contenuPrincipal: some View {
        VStack(spacing: 20) {
            BoiteTitre(
                titre: $titre,
                overlayActif: $overlayActif,
                titreLimite: titreLimite
            )
            
            boutonsOption
            
            sectionCarte
            
            sectionParticipantsEtInvitations
            
            BoiteDescription(
                description: $description,
                overlayActif: $overlayActif,
                descriptionLimite: descriptionLimite
            )
            
            boutonInviterTeammates
            
        }
        .padding(.horizontal)
        .padding(.top, 40)
        .navigationTitle("Create an activity")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var boutonsOption: some View {
        VStack(spacing: 20) {
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
        }
    }
    
    private var sectionCarte: some View {
        VStack(spacing: 8) {
            BoutonAvecApercuCarte(sportChoisis: $sportChoisis, infraChoisie: $infraChoisie)
                .padding(.horizontal)
                .environmentObject(emplacementsVM)
            
            Text((infraChoisie != nil) ? "A marker has been selected" : "Click on the map to select a marker")
                .font(.caption)
                .foregroundStyle(Color(red: 0.3, green: 0.3, blue: 0.3))
        }
    }

    private var sectionParticipantsEtInvitations: some View {
        VStack(spacing: 20) {
            BoutonOptionOverlay(
                icon: "person.2",
                text: texteParticipants,
                action: { overlayActif = .participants }
            )
            
            BoutonOptionOverlay(
                icon: "envelope.open",
                text: texteInvitations,
                action: { overlayActif = .invites }
            )
        }
    }

    private var boutonInviterTeammates: some View {
        Button {
            // action d'invitation
        } label: {
            Label("Invite teammates", systemImage: "person.2.badge.plus")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .tint(Color("CouleurParDefaut"))
        .controlSize(.large)
        .padding(.horizontal)
        .padding(.bottom, 10)
    }

    @ToolbarContentBuilder
    private var contenuToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Close") { dismiss() }
                .foregroundStyle(.black)
        }
        
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button {
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil, from: nil, for: nil
                )
            } label: {
                Image(systemName: "keyboard.chevron.compact.down")
            }
        }
    }

    private var barAction: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                boutonCreer
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
            .ignoresSafeArea(edges: .bottom)
        }
    }
    
    private var boutonCreer: some View {
        Button {
            vm.infraChoisie = infraChoisie
            Task {
                if await vm.existeActivitesDejaCreer(
                    for: infraChoisie!.id, // unwrappable
                    debutActivite: tempsDebut,
                    finActivite: tempsFin
                ) {
                    montrerAlerteChevauchement = true
                } else {
                    await vm.creerActivite(
                        nbParticipants: nbParticipants,
                        permettreInvitations: permettreInvitations,
                        description: description,
                        tempsDebut: tempsDebut,
                        tempsFin: tempsFin,
                        dateSelectionnee: dateSelectionnee,
                        titre: titre,
                        sportSelectionne: sportSelectionne
                    )
                    dismiss()
                }
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                Text("Create")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(.borderedProminent)
        .tint(Color("CouleurParDefaut"))
        .controlSize(.large)
        .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
        .opacity(estDesactiver ? 0.6 : 1)
        .disabled(estDesactiver)
        .alert("Overlapping detected", isPresented: $montrerAlerteChevauchement) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("An activity is already planned at this infrastructure for the selected time.")
        }
    }

    private var estDesactiver: Bool {
        titre.isEmpty || nbParticipants == 0 || infraChoisie == nil || montrerAlerteChevauchement
    }
    
    struct BoiteTitre: View {
        @Binding var titre: String
        @Binding var overlayActif: ActiveOverlay
        let titreLimite: Int
        
        var body: some View {
            VStack {
                TextField("Title of the activity", text: $titre)
                    .padding(.leading, 16)
                    .frame(minHeight: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .shadow(color: Color.gray.opacity(0.1), radius: 2, x: 0, y: 1)
                    )
                    .onReceive(Just(titre)) { _ in limiterTexte(titreLimite) }
                    .disabled(overlayActif != .none)
            }
            .padding(.horizontal)
        }
        
        func limiterTexte(_ upper: Int) {
            if titre.count > upper {
                titre = String(titre.prefix(upper))
            }
        }
    }
    
    struct BoiteDescription: View {
        @Binding var description: String
        @Binding var overlayActif: ActiveOverlay
        let descriptionLimite: Int

        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text("Description")
                    .font(.headline)
                
                Text("Maximum of \(descriptionLimite) characters")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom, 4)
                
                TextEditor(text: $description)
                    .frame(minHeight: 100)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    )
                    .onReceive(Just(description)) { _ in limiterTexte(descriptionLimite) }
                    .disabled(overlayActif != .none)
            }
            .padding(.horizontal)
        }
        
        func limiterTexte(_ upper: Int) {
            if description.count > upper {
                description = String(description.prefix(upper))
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
        FenetreModaleFlottante(estPresente: Binding(
            get: { overlayActif == .sport },
            set: { if !$0 { overlayActif = .none } }
        )) {
            VStack(spacing: 16) {
                VStack(spacing: 0) {
                    Text("Select a sport")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(Sport.allCases, id: \.self) { sport in
                                Button {
                                    sportSelectionTemporaire = sport
                                } label: {
                                    HStack {
                                        Image(systemName: sport.icone)
                                        Text(sport.nom.capitalized)
                                        Spacer()
                                    }
                                    .foregroundColor(sportSelectionTemporaire == sport ? Color("CouleurParDefaut") : .black)
                                    .padding(.horizontal)
                                    .padding(.vertical, 14)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.top, 20)
                }
                .padding([.top, .trailing, .leading], 30)
                .padding(.bottom, 10)
                
                VStack(spacing: 0) {
                  Divider()

                  HStack(spacing: 0) {
                    Button(action: {
                        sportSelectionTemporaire = sportSelectionne
                        overlayActif = .none
                    }) {
                      Text("Close")
                        .frame(maxWidth: .infinity, maxHeight: 60)
                    }
                    .foregroundColor(.primary)
                    .fontWeight(.semibold)

                    Divider()
                      .frame(width: 1, height: 60)

                    Button(action: {
                      if let sportConfirme = sportSelectionTemporaire {
                          sportSelectionne = sportConfirme
                          sportChoisis = [sportConfirme.nom.capitalized]
                      }
                      overlayActif = .none
                    }) {
                      Text("OK")
                        .frame(maxWidth: .infinity, maxHeight: 60)
                    }
                    .foregroundColor(Color("CouleurParDefaut"))
                  }
                }
            }
            .frame(width: 300)
        }
    }


    private var pickerPourDate: some View {
        FenetreModaleFlottante(estPresente: Binding(
            get: { overlayActif == .date },
            set: { if !$0 { overlayActif = .none } }
        )) {
            VStack(spacing: 8) {
                VStack(spacing: 8) {
                    Text("Select a date")
                        .font(.title3)
                        .fontWeight(.semibold)

                    DatePicker(
                        "",
                        selection: Binding(
                            get: { dateSelectionneeSelectionTemporaire ?? dateSelectionnee },
                            set: { dateSelectionneeSelectionTemporaire = $0 }
                        ),
                        in: dateMin...dateMax,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .accentColor(Color("CouleurParDefaut"))
                }
                .padding([.top, .leading, .trailing], 30)
                .padding(.bottom, 10)

                // --- Barre Close / OK
                VStack(spacing: 0) {
                    Divider()
                    
                    HStack(spacing: 0) {
                        Button("Close") {
                            dateSelectionneeSelectionTemporaire = dateSelectionnee
                            overlayActif = .none
                        }
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .foregroundColor(.primary)
                        .fontWeight(.semibold)

                        Divider()
                            .frame(width: 1, height: 60)

                        Button("OK") {
                            if let d = dateSelectionneeSelectionTemporaire {
                                dateSelectionnee = d
                            }
                            overlayActif = .none
                        }
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .foregroundColor(Color("CouleurParDefaut"))
                        .fontWeight(.semibold)
                    }
                }
            }
            .frame(width: 300)
        }
    }

    private var pickerPourHeure: some View {
        FenetreModaleFlottante(estPresente: Binding(
            get: { overlayActif == .temps },
            set: { if !$0 { overlayActif = .none } }
        )) {
            VStack(spacing: 0) {
                // Calcul des bornes 06:00 et 22:00 du même jour
                let calendrier = Calendar.current
                let debutDeJournee = calendrier.startOfDay(for: dateSelectionnee)
                let tempsMin = calendrier.date(byAdding: .hour, value: 6,  to: debutDeJournee)!
                let tempsMax = calendrier.date(byAdding: .hour, value: 22, to: debutDeJournee)!

                // Initialisation des temporaires à l’apparition
                Color.clear.onAppear {
                    tempsDebutSelectionTemporaire = tempsDebut
                    tempsFinSelectionTemporaire = tempsFin
                }

                let startBinding = Binding<Date>(
                    get: { tempsDebutSelectionTemporaire! },
                    set: { new in
                        tempsDebutSelectionTemporaire = new
                        // maintien de fin ≥ début
                        if new > tempsFinSelectionTemporaire! {
                            tempsFinSelectionTemporaire = new
                        }
                    }
                )
                let endBinding = Binding<Date>(
                    get: { tempsFinSelectionTemporaire! },
                    set: { tempsFinSelectionTemporaire = $0 }
                )

                // Roulettes avec restriction
                VStack(spacing: 20) {
                    VStack {
                        Text("Start time")
                            .font(.title3).fontWeight(.semibold)
                        DatePicker(
                            "",
                            selection: startBinding,
                            in: tempsMin...tempsMax,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                    }
                    VStack {
                        Text("End time")
                            .font(.title3).fontWeight(.semibold)
                        DatePicker(
                            "",
                            selection: endBinding,
                            // on interdit avant 6h et après 22h,
                            // et on bloque aussi en dessous du début choisi
                            in: max(startBinding.wrappedValue, tempsMin)...tempsMax,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                    }
                }
                .padding([.top, .leading, .trailing], 30)
                .padding(.bottom, 10)

                // Barre Close / OK
                Divider()
                HStack(spacing: 0) {
                    Button("Close") {
                        // on annule les temporaires
                        tempsDebutSelectionTemporaire = tempsDebut
                        tempsFinSelectionTemporaire = tempsFin
                        overlayActif = .none
                    }
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .foregroundColor(.primary)
                    .fontWeight(.semibold)

                    Divider().frame(width: 1, height: 60)

                    Button("OK") {
                        // on commit en veillant à ne jamais sortir des bornes
                        let sd = tempsDebutSelectionTemporaire!
                        var ef = tempsFinSelectionTemporaire!

                        // si ef < sd, recaler ef = sd
                        if ef < sd { ef = sd }

                        tempsDebut = sd
                        tempsFin = ef
                        overlayActif = .none
                    }
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .foregroundColor(Color("CouleurParDefaut"))
                    .fontWeight(.semibold)
                }
            }
            .frame(width: 300)
        }
    }


    private var pickerPourParticipants: some View {
        FenetreModaleFlottante(estPresente: Binding(
            get: { overlayActif == .participants },
            set: { if !$0 { overlayActif = .none } }
        )) {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Text("Select number")
                        .font(.title3)
                        .fontWeight(.semibold)

                    Picker(
                        "",
                        selection: Binding(
                            get: { nbParticipantsSelectionTemporaire ?? nbParticipants },
                            set: { nbParticipantsSelectionTemporaire = $0 }
                        )
                    ) {
                        ForEach(0..<16, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 150)
                    .clipped()
                }
                .padding([.top, .leading, .trailing], 30)
                .padding(.bottom, 10)

                // --- Barre Close / OK
                Divider()
                HStack(spacing: 0) {
                    Button("Close") {
                        nbParticipantsSelectionTemporaire = nbParticipants
                        overlayActif = .none
                    }
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .foregroundColor(.primary)
                    .fontWeight(.semibold)

                    Divider()
                        .frame(width: 1, height: 60)

                    Button("OK") {
                        nbParticipants = nbParticipantsSelectionTemporaire!
                        overlayActif = .none
                    }
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .foregroundColor(Color("CouleurParDefaut"))
                    .fontWeight(.semibold)
                }
            }
            .frame(width: 300)
        }
    }

    private var pickerPourInvites: some View {
      FenetreModaleFlottante(estPresente: Binding(
          get: { overlayActif == .invites },
          set: { if !$0 { overlayActif = .none } }
      )) {
        VStack(spacing: 0) {
          VStack(spacing: 0) {
            Text("Guests invitations")
              .font(.title3)
              .fontWeight(.semibold)

            VStack(spacing: 10) {
              Button {
                permettreInvitationsSelectionTemporaire = true
              } label: {
                Label("Authorize", systemImage: "figure.child.and.lock.open.fill")
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .padding()
                  .background(Color(.systemGray6))
                  .foregroundColor(permettreInvitationsSelectionTemporaire ? Color("CouleurParDefaut") : .black)
                  .cornerRadius(8)
              }
              .buttonStyle(.plain)

              Button {
                permettreInvitationsSelectionTemporaire = false
              } label: {
                Label("Disallow", systemImage: "figure.child.and.lock.fill")
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .padding()
                  .background(Color(.systemGray6))
                  .foregroundColor(!permettreInvitationsSelectionTemporaire ? Color("CouleurParDefaut") : .black)
                  .cornerRadius(8)
              }
              .buttonStyle(.plain)
            }
            .padding(.top, 20)
          }
          .padding([.top, .leading, .trailing], 30)
          .padding(.bottom, 25)

          // --- Barre Close / OK
          Divider()
          HStack(spacing: 0) {
            Button("Close") {
                if permettreInvitationsSelectionTemporaire && !permettreInvitations {
                    permettreInvitationsSelectionTemporaire = false
                } else if !permettreInvitationsSelectionTemporaire && permettreInvitations {
                    permettreInvitationsSelectionTemporaire = true
                }
                overlayActif = .none
            }
            .frame(maxWidth: .infinity, maxHeight: 60)
            .foregroundColor(.primary)
            .fontWeight(.semibold)

            Divider().frame(width: 1, height: 60)

            Button("OK") {
                permettreInvitations = permettreInvitationsSelectionTemporaire
                overlayActif = .none
            }
            .frame(maxWidth: .infinity, maxHeight: 60)
            .foregroundColor(Color("CouleurParDefaut"))
            .fontWeight(.semibold)
          }
        }
        .frame(width: 300)
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
        if nbParticipants > 0 {
            return "\(nbParticipants) participant\(nbParticipants > 1 ? "s" : "")"
        } else {
            return "Number of participants"
        }
    }
    private var texteInvitations: String {
        return permettreInvitations ? "I authorize guests invitations" : "I disallow guests invitations"
    }
}

struct BoutonOptionOverlay: View {
    let icon: String, text: String, action: () -> Void
    var body: some View {
        Button(action: action) {
            BoiteAvecChevron(showChevron: true) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.red)
                Text(text).foregroundColor(.black)
            }
        }.buttonStyle(.plain)
    }
}

#Preview {
    CreerActiviteVue()
        .environmentObject(DonneesEmplacementService())
}

