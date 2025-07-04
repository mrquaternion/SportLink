//
//  CreerActivitesVue.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-06-21.
//


import SwiftUI
import CoreLocation

struct CreerVue: View {
    @Environment(\.dismiss) var dismiss

    @State private var selectedSport: Sport = .soccer
    @State private var showSportOverlay = false

    @State private var selectedDate: Date = Date()
    @State private var showDateOverlay = false
    
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
    @State private var showTimeOverlay = false
    
    @State private var selectedLocation: CLLocationCoordinate2D? = nil
    
    @State private var participants: Int? = nil
    @State private var showParticipantsOverlay = false
    
    @State private var allowGuests: Bool? = nil
    @State private var showGuestsOverlay = false



    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Spacer().frame(height: 8)
                
                // Choix Sport
                Button {
                    showSportOverlay = true
                } label: {
                    RectangleVue(showChevron: true) {
                        Image(systemName: selectedSport.icone)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.red)
                        
                        Text(selectedSport.nom.capitalized)
                            .foregroundColor(.black)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                // Choix Date
                Button {
                    showDateOverlay = true
                } label: {
                    RectangleVue(showChevron: true) {
                        Image(systemName: "calendar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.red)
                        
                        Text(dateString)
                            .foregroundColor(.black)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                // Start + End Time
                Button {
                    showTimeOverlay = true
                } label: {
                    RectangleVue(showChevron: true) {
                        Image(systemName: "clock")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.red)
                        
                        Text("\(startTimeString) à \(endTimeString)")
                            .foregroundColor(.black)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                // Location
                VStack(alignment: .leading, spacing: 8) {
                    Text("Location")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    CarteSelectionVue(selectedLocation: $selectedLocation)
                }
                .padding(.horizontal)
                
                // Nombre Participants
                Button {
                    showParticipantsOverlay = true
                } label: {
                    RectangleVue(showChevron: true) {
                        Image(systemName: "person.3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 20)
                            .foregroundColor(.red)
                        
                        Text(participantsText)
                            .foregroundColor(.black)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                // Invitation
                Button {
                    showGuestsOverlay = true
                } label: {
                    RectangleVue(showChevron: true) {
                        Image(systemName: "person.2.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 20)
                            .foregroundColor(.red)
                        
                        guestsLabel
                            .foregroundColor(.black)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                
                // Bouton Invitation
                HStack {
                    Spacer()
                    
                    Button(action: {
                        // Action d'invitation
                        print("Inviter des coéquipiers…")
                    }) {
                        Text("Invite teammates")
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                    .frame(width: 250)
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(12)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Bouton Créer
                Button(action: {
                    guard let location = selectedLocation else {
                        print("Erreur : aucune position sélectionnée.")
                        return
                    }
                    
                    print("Sport : \(selectedSport)")
                    print("Date : \(selectedDate)")
                    print("Heure : \(startTime) à \(endTime)")
                    print("Participants : \(participants ?? 0)")
                    print("Autorisation : \(allowGuests ?? false)")
                    print("Coordonnées : \(location.latitude), \(location.longitude)")
                }) {
                    Text("Create")
                        .bold()
                        .frame(width: 150)
                        .frame(height: 50)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                        .padding(.horizontal)
                }
            }

            
            // Heure de fin toujour après heure de début (1 heure de différence)
            .onChange(of: startTime) { _, newStart in
                if endTime < newStart {
                    endTime = Calendar.current.date(byAdding: .hour, value: 1, to: newStart) ?? newStart
                }
            }

            .navigationTitle("Create an activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(.systemGray6), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                    }
                }
            }
            
            
            // Les Overlay
            .overlay(
                Group {
                    
                    // Sport
                    if showSportOverlay {
                        CustomOverlay(isPresented: $showSportOverlay) {
                            VStack(spacing: 16) {
                                Text("Choisir un sport")
                                    .font(.headline)

                                ScrollView {
                                    VStack(spacing: 8) {
                                        ForEach(Sport.allCases, id: \.self) { sport in
                                            Button {
                                                selectedSport = sport
                                                showSportOverlay = false
                                            } label: {
                                                HStack {
                                                    Image(systemName: sport.icone)
                                                        .foregroundColor(.red)
                                                    Text(sport.nom.capitalized)
                                                        .foregroundColor(.red)
                                                    Spacer()
                                                }
                                                .padding()
                                                .frame(maxWidth: .infinity)
                                                .background(Color(.systemGray6))
                                                .cornerRadius(8)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                }

                                Button("Fermer") {
                                    showSportOverlay = false
                                }
                                .padding(.top, 8)
                            }
                            .padding()
                        }
                    }
                    
                    // Date
                    if showDateOverlay {
                        CustomOverlay(isPresented: $showDateOverlay) {
                            VStack(spacing: 16) {
                                Text("Choisir une date")
                                    .font(.headline)

                                DatePicker(
                                    "",
                                    selection: $selectedDate,
                                    displayedComponents: .date
                                )
                                .datePickerStyle(.graphical)
                                .labelsHidden()
                                .frame(maxHeight: 300)

                                Button("Fermer") {
                                    showDateOverlay = false
                                }
                            }
                            .padding()
                        }
                    }
                    
                    // Début - Fin Heure
                    if showTimeOverlay {
                        CustomOverlay(isPresented: $showTimeOverlay) {
                            VStack(spacing: 16) {
                                Text("Choisir l'heure")
                                    .font(.headline)

                                VStack(spacing: 12) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "clock")
                                            .foregroundColor(.red)
                                        Text("Début")
                                            .font(.subheadline)
                                        DatePicker(
                                            "",
                                            selection: $startTime,
                                            displayedComponents: .hourAndMinute
                                        )
                                        .datePickerStyle(.compact)
                                        .labelsHidden()
                                        .tint(.red)
                                    }

                                    HStack(spacing: 12) {
                                        Image(systemName: "clock")
                                            .foregroundColor(.red)
                                        Text("Fin")
                                            .font(.subheadline)
                                        DatePicker(
                                            "",
                                            selection: $endTime,
                                            in: startTime...,
                                            displayedComponents: .hourAndMinute
                                        )
                                        .datePickerStyle(.compact)
                                        .labelsHidden()
                                        .tint(.red)
                                    }
                                }

                                Button("Fermer") {
                                    showTimeOverlay = false
                                }
                            }
                            .padding()
                            .frame(maxWidth: 300)
                        }
                    }
                    
                    // Nombre Participants
                    if showParticipantsOverlay {
                        CustomOverlay(isPresented: $showParticipantsOverlay) {
                            VStack(spacing: 16) {
                                Text("Choisir un nombre de participant(s)")
                                    .font(.headline)

                                Picker("Participants", selection: Binding(
                                    get: { participants ?? 0 },
                                    set: { participants = $0 }
                                )) {
                                    ForEach(0..<16) { number in
                                        Text("\(number)")
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 150)
                                .clipped()

                                Button("Confirmer") {
                                    showParticipantsOverlay = false
                                }
                            }
                            .padding()
                            .frame(maxWidth: 300)
                        }
                    }
                    
                    // Invitation
                    if showGuestsOverlay {
                        CustomOverlay(isPresented: $showGuestsOverlay) {
                            VStack(spacing: 16) {
                                Text("Participants : autorisation d’inviter")
                                    .font(.headline)

                                VStack(spacing: 12) {
                                    Button {
                                        allowGuests = true
                                        showGuestsOverlay = false
                                    } label: {
                                        Label("J'autorise les invitations", systemImage: "figure.child.and.lock.open.fill")
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color(.systemGray6))
                                            .cornerRadius(8)
                                    }
                                    .buttonStyle(PlainButtonStyle())

                                    Button {
                                        allowGuests = false
                                        showGuestsOverlay = false
                                    } label: {
                                        Label("Je n'autorise pas les invitations", systemImage: "figure.child.and.lock.fill")
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color(.systemGray6))
                                            .cornerRadius(8)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }

                                Button("Fermer") {
                                    showGuestsOverlay = false
                                }
                                .padding(.top, 8)
                            }
                            .padding()
                            .frame(maxWidth: 300)
                        }
                    }






                }
            )
        }
    }

    // Formatter date
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: selectedDate)
    }
    
    // Formater Heure Début
    var startTimeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: startTime)
    }

    // Formater Heure Fin
    var endTimeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: endTime)
    }
    
    // Formatter Participant
    var participantsText: String {
        if let count = participants {
            return "\(count) participant" + (count > 1 ? "s" : "")
        } else {
            return "Choisir un nombre de participant(s)"
        }
    }
    
    // Formater Invitation
    var guestsLabel: some View {
        if let allow = allowGuests {
            AnyView(
                HStack {
                    Text(allow ? "J'autorise les invitations" : "Je n'autorise pas les invitations")
                    Image(systemName: allow ? "figure.child.and.lock.open.fill" : "figure.child.and.lock.fill")
                }
            )
        } else {
            AnyView(
                Text("Participants : autorisation d’inviter")
            )
        }
    }





}

#Preview {
    CreerVue()
}

