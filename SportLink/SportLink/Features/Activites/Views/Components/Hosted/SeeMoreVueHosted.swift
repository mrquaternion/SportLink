//
//  SeeMoreVueHosted.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-15.
//


import SwiftUI
import MapKit

struct SeeMoreVueHosted: View {
    let titre: String
    let sport: Sport
    let debut: Date
    let fin: Date
    let nomParc: String
    let infrastructure: Infrastructure
    let nbPlacesDisponibles: Int
    let invitationsOuvertes: Bool
    @State private var afficherVueEdition = false

    @Environment(\.dismiss) var dismiss

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
                Text(titre)
                    .font(.title)
                    .bold()
                    .padding(.horizontal)

                // Sport
                HStack(spacing: 8) {
                    Image(systemName: sport.icone)
                        .foregroundColor(.red)
                        .font(.title2)

                    Text(sport.nom.capitalized)
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
                    Text("\(dateFormatter.string(from: debut).capitalizedFirstLetter())")
                        .font(.title3)
                        .foregroundColor(.black)
                }
                .padding(.horizontal)

                // Heure
                HStack(spacing: 8) {
                    Image(systemName: "clock")
                        .foregroundColor(Color("CouleurParDefaut"))
                        .font(.title3)

                    Text("\(formatter.string(from: debut)) - \(formatter.string(from: fin))")
                        .font(.title3)
                        .foregroundColor(.black)
                }
                .padding(.horizontal)

                // ➤ Bloc sans espacement vertical entre ses éléments
                Group {
                    Text(nomParc)
                        .font(.title3)
                        .padding(.horizontal)
                        .padding(.bottom, -12)
                        
                    CarteParcSeeMore(infrastructure: infrastructure)
                        .frame(height: 300)
                        .cornerRadius(12)
                        .padding(.horizontal)

                    BoutonOuvrirDansPlans(coordonnees: infrastructure.coordonnees)
                }

                // Places disponibles
                HStack(spacing: 8) {
                    Image(systemName: "person.2")
                        .foregroundColor(Color("CouleurParDefaut"))
                        .font(.headline)
                    Text("Places disponibles : \(nbPlacesDisponibles)")
                        .foregroundColor(.black)
                        .font(.title3)
                }
                .padding(.horizontal)
                .padding(.top, 4)

                // Invitations invité.e.s
                HStack(spacing: 8) {
                    Image(systemName: invitationsOuvertes ? "envelope.open" : "figure.child.and.lock.fill")
                        .foregroundColor(Color("CouleurParDefaut"))

                    Text(invitationsOuvertes ? "Open to guests invitations" : "Close to guests invitations")
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
    NavigationStack {
        SeeMoreVueHosted(
            titre: "Tournoi de soccer",
            sport: .soccer,
            debut: Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date())!,
            fin: Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date())!,
            nomParc: "Parc Laurier",
            infrastructure: Infrastructure(
                id: "mock",
                indexParc: "0",
                coordonnees: CLLocationCoordinate2D(latitude: 45.5, longitude: -73.56),
                sport: [.soccer]
            ),
            nbPlacesDisponibles: 5,
            invitationsOuvertes : true
        )
    }
}
