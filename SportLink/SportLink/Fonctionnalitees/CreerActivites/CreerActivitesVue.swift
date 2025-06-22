//
//  CreerActivitesVue.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-06-21.
//

import SwiftUI
import CoreLocation


struct CreerActiviteVue: View {
    @Environment(\.dismiss) var dismiss

    @State private var selectedSport: Sport = .soccer
    @State private var selectedDate = Date()
    @State private var startTime = Date()
    @State private var endTime = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
    @State private var participants = 0
    @State private var allowGuests = false
    @State private var selectedLocation: CLLocationCoordinate2D? = nil


    var body: some View {
        VStack(spacing: 16) {
            // Vagues et flèche retour
            ZStack(alignment: .topLeading) {
                VaguesVue()
                    .frame(height: 150)

                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 26))
                        .padding()
                        .foregroundColor(.black)
                }
                .padding(.top, 16)
                .padding(.leading, 16)
            }
            
            Spacer()
                .frame(height: 30)
            
            Text("Create an activity")
                .font(.title)
                .bold()
                .padding(.top, 16)

            // Choix Sport
            HStack(alignment: .top, spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Sport")
                        .font(.headline)
                    Picker("Sport", selection: $selectedSport) {
                        ForEach(Sport.allCases, id: \.self) { sport in
                            Text(sport.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(.horizontal)
                    .frame(height: 44)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                // Date
                VStack(alignment: .leading, spacing: 4) {
                    Text("Select a date")
                        .font(.headline)
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .labelsHidden()
                        .datePickerStyle(.compact)
                }
            }
            .padding(.horizontal)

            // Ligne Time Start + Time End
            HStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Start Time")
                        .font(.subheadline)
                    DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(.compact)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("End Time")
                        .font(.subheadline)
                    DatePicker(
                        "",
                        selection: $endTime,
                        in: startTime...,
                        displayedComponents: .hourAndMinute
                    )
                    .labelsHidden()
                    .datePickerStyle(.compact)
                }
            }
            .padding(.horizontal)
            .onChange(of: startTime) { _, newStart in
                if endTime < newStart {
                    endTime = Calendar.current.date(byAdding: .hour, value: 1, to: newStart) ?? newStart
                }
            }
            
            // 📍 Location
            VStack(alignment: .leading, spacing: 8) {
                Text("Location")
                    .font(.headline)
                    .padding(.horizontal)
                CarteSelectionVue(selectedLocation: $selectedLocation)


            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 16) {
                    // Participants
                    VStack(alignment: .leading, spacing: 4) {
                        Text("# Participants")
                            .font(.subheadline)
                            .padding(.leading, 8) 

                        HStack {
                            Text("\(participants, specifier: "%02d")")
                                .font(.title3)
                                .frame(width: 50)
                                .padding(6)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)

                            VStack(spacing: 4) {
                                Button(action: { participants += 1 }) {
                                    Image(systemName: "plus.circle")
                                        .font(.title3)
                                }
                                Button(action: {
                                    if participants > 0 { participants -= 1 }
                                }) {
                                    Image(systemName: "minus.circle")
                                        .font(.title3)
                                }
                            }
                        }
                    }

                    // Toggle + invite teammate
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Toggle("", isOn: $allowGuests)
                                .labelsHidden()
                            Text("Allow guest invitations")
                                .font(.subheadline)
                        }

                        Button(action: {
                            // action
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Invite teammates")
                            }
                            .padding()
                            .frame(width: 180) // 🔁 Moins large pour rester à gauche
                            .background(Color(.systemGray5))
                            .foregroundColor(.red)
                            .cornerRadius(10)
                        }
                        .disabled(true)
                        .opacity(0.5)
                    }
                    .padding(.leading, -8) // 🔁 Décale vers la gauche le bloc Toggle + bouton
                }
            }
            .padding(.horizontal)


            Spacer()

            // Creer button
            Button("Create") {
                guard let location = selectedLocation else {
                    print("Erreur : aucune position sélectionnée.")
                    return
                }

                print("Sport : \(selectedSport)")
                print("Date : \(selectedDate)")
                print("Heure : \(startTime) à \(endTime)")
                print("Coordonnées : \(location.latitude), \(location.longitude)")
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(30)
            .padding(.horizontal)

        }
        .edgesIgnoringSafeArea(.top)
    }
}


#Preview {
    CreerActiviteVue()
}
