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
    @State private var selectedDate = Date()
    @State private var startTime = Date()
    @State private var endTime = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
    @State private var participants = 0
    @State private var allowGuests = false
    @State private var selectedLocation: CLLocationCoordinate2D? = nil
    @State private var showGuestInfo = false


    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Vagues
                /*VaguesVue()
                    .frame(height: 150)
                
                Spacer()
                    .frame(height: 30)
                
                HStack {
                    Text("Close")
                    
                    Text("Create an activity")
                        .font(.title)
                        .bold()
                        .padding(.top, 16)
                }*/
                
                Spacer()
                
                
                // Choix Sport
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: selectedSport.icone) // ✅ Exemple d’icône SF Symbols pour Sport
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        
                        Picker("Sport", selection: $selectedSport) {
                            ForEach(Sport.allCases, id: \.self) { sport in
                                Text(sport.rawValue.capitalized)
                                    .foregroundStyle(.black)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                        .tint(.red)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    
                }
                .padding(.horizontal)
                
                
                // Select a date
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "calendar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        
                        DatePicker("", selection: $selectedDate, displayedComponents: .date)
                            .labelsHidden()
                            .datePickerStyle(.compact)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    
                }
                .padding(.horizontal)
                
                
                // Start Time + End Time
                HStack(spacing: 4) {
                    // Icône Start Time
                    Image(systemName: "clock")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    // DatePicker Start Time
                    DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(.compact)
                    
                    // Texte "to"
                    Text("to")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // DatePicker End Time
                    DatePicker(
                        "",
                        selection: $endTime,
                        in: startTime...,
                        displayedComponents: .hourAndMinute
                    )
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                .padding(.horizontal)
                .onChange(of: startTime) { _, newStart in
                    if endTime < newStart {
                        endTime = Calendar.current.date(byAdding: .hour, value: 1, to: newStart) ?? newStart
                    }
                }
                
                
                //Location
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
                            HStack(spacing: 8) {
                                Image(systemName: "person.3")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 20)
                                
                                Picker("Participants", selection: $participants) {
                                    ForEach(0..<16) { number in
                                        Text("\(number)")
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 80)
                                .clipped()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        
                        // Toggle + Invite teammates
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: "person.2.badge.plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 20)
                                
                                Toggle(isOn: $allowGuests) {
                                    Image(systemName: "person.2.badge.plus")
                                        .resizable()
                                        .frame(width: 24, height: 20)
                                }
                                .labelsHidden()
                                
                                Button(action: {
                                    showGuestInfo = true
                                }) {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Button(action: {
                                // Action pour inviter
                            }) {
                                HStack {
                                    Text("Invite teammates")
                                        .bold()
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .frame(width: 180)
                                .background(Color.red)
                                .cornerRadius(20)
                            }
                            .disabled(true)
                            .opacity(0.5)
                        }
                        .padding(.leading, -8)
                    }
                }
                .padding(.horizontal)
                .sheet(isPresented: $showGuestInfo) {
                    VStack(spacing: 20) {
                        Text("Allow guest invitations")
                            .font(.headline)
                            .padding()
                        
                        Text("When enabled, participants can invite guests to join the activity.")
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button("Close") {
                            showGuestInfo = false
                        }
                        .padding()
                    }
                    .presentationDetents([.fraction(0.2)])
                }
                
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
            .navigationTitle("Create an activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}


#Preview {
    CreerVue()
}
