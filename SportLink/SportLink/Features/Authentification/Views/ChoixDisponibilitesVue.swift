//
//  ChoixDisponibilitesVue.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-24.
//

import SwiftUI

let joursDeLaSemaine = [
    "Monday", "Tuesday", "Wednesday",
    "Thursday", "Friday", "Saturday", "Sunday"
]

struct ChoixDisponibilitesVue: View {
    @ObservedObject var authVM: AuthentificationVM
    let sportsChoisis: [String]

    @State private var joursSelectionnes: Set<String> = []
    @State private var disponibilites: [String: [(Date, Date)]] = [:]
    @State private var overlayJourActif: (jour: String, index: Int)? = nil

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Select Your Weekly Availability")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, 30)
                        .padding(.horizontal)

                    ForEach(joursDeLaSemaine, id: \.self) { jour in
                        VStack(spacing: 10) {
                            Button {
                                if joursSelectionnes.contains(jour) {
                                    joursSelectionnes.remove(jour)
                                    disponibilites.removeValue(forKey: jour)
                                } else {
                                    joursSelectionnes.insert(jour)
                                    disponibilites[jour] = [
                                        (Date(), Calendar.current.date(byAdding: .hour, value: 1, to: Date())!)
                                    ]
                                }
                            } label: {
                                HStack {
                                    Text(jour)
                                        .foregroundColor(.black)
                                    Spacer()
                                    Image(systemName: joursSelectionnes.contains(jour) ? "checkmark.square.fill" : "square")
                                        .foregroundColor(.red)
                                }
                                .padding(.horizontal)
                            }

                            if let plages = disponibilites[jour], joursSelectionnes.contains(jour) {
                                ForEach(Array(plages.enumerated()), id: \.offset) { index, plage in
                                    Button {
                                        overlayJourActif = (jour, index)
                                    } label: {
                                        BoiteAvecChevron {
                                            Image(systemName: "clock")
                                                .foregroundColor(.red)
                                            Text("\(formater(plage.0)) to \(formater(plage.1))")
                                                .foregroundColor(.black)
                                        }
                                    }
                                    .padding(.horizontal)
                                }

                                Button {
                                    disponibilites[jour, default: []].append(
                                        (Date(), Calendar.current.date(byAdding: .hour, value: 1, to: Date())!)
                                    )
                                } label: {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundColor(.red)
                                        Text("Add time slot")
                                            .foregroundColor(.red)
                                    }
                                    .padding(.horizontal)
                                }
                            }

                            Divider()
                        }
                    }

                    Spacer(minLength: 60) // pour ne pas que le scroll cache le bouton
                }
            }

            // Bouton "Continue" fixé en bas
            VStack(spacing: 0) {
                Divider()
                Button("Continue") {
                    // Action ici
                }
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .cornerRadius(30)
                .padding(.horizontal, 50)
                .padding(.vertical, 10)
            }
            .background(.ultraThinMaterial)
        }
        .overlay(overlayModale)
        .navigationBarBackButtonHidden(true)
    }

    // Overlay modale pour une plage horaire
    private var overlayModale: some View {
        Group {
            if let (jour, index) = overlayJourActif,
               disponibilites[jour]?.indices.contains(index) == true {
                FenetreModaleFlottante(estPresente: Binding(
                    get: { overlayJourActif != nil },
                    set: { if !$0 { overlayJourActif = nil } }
                )) {
                    VStack(spacing: 20) {
                        Text("Set time for \(jour)")
                            .font(.headline)
                            .padding(.top, 16)

                        let bindingDebut = Binding<Date>(
                            get: { disponibilites[jour]![index].0 },
                            set: { disponibilites[jour]![index].0 = $0 }
                        )
                        let bindingFin = Binding<Date>(
                            get: { disponibilites[jour]![index].1 },
                            set: { disponibilites[jour]![index].1 = $0 }
                        )

                        VStack(spacing: 16) {
                            VStack {
                                Text("Start")
                                DatePicker("", selection: bindingDebut, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .datePickerStyle(.wheel)
                            }

                            VStack {
                                Text("End")
                                DatePicker("", selection: bindingFin, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .datePickerStyle(.wheel)
                            }
                        }
                        .padding(.bottom, 10)

                        Divider()

                        HStack(spacing: 0) {
                            Button("Close") {
                                overlayJourActif = nil
                            }
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .foregroundColor(.primary)
                            .fontWeight(.semibold)

                            Divider().frame(width: 1, height: 60)

                            Button("OK") {
                                overlayJourActif = nil
                            }
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .foregroundColor(Color("CouleurParDefaut"))
                            .fontWeight(.semibold)
                        }
                    }
                    .frame(width: 300)
                }
            }
        }
    }

    // Formatter pour afficher les heures
    func formater(_ date: Date) -> String {
        date.formatted(date: .omitted, time: .shortened)
    }
}

#Preview {
    ChoixDisponibilitesVue(
        authVM: AuthentificationVM(),
        sportsChoisis: ["soccer", "tennis", "basketball"]
    )
}

