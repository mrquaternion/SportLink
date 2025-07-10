//
//  ActiviteBoite.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-09.
//


import SwiftUI

struct ActiviteBoite: View {
    let titre: String
    let sport: Sport
    let infraNom: String
    let date: DateInterval
    let nbPlacesRestantes: Int
    let imageApercu: UIImage?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("\(titre) - \(sport.nom.capitalized)")
                    .font(.headline)
                    .foregroundColor(.black)

                Image(systemName: sport.icone)

                Spacer()

                Button("Cancel") {
                    // TODO: Action annuler
                }
                .foregroundColor(.red)
                .font(.callout)
            }

            HStack(spacing: 4) {
                Text(infraNom)
                    .font(.subheadline)
                    .foregroundColor(.black)

                Text("on \(dateEnString) from \(heureDebut) to \(heureFin)")
                    .font(.subheadline)
                    .foregroundColor(.black)

                Text("|")

                Text("\(nbPlacesRestantes) places left")
                    .font(.subheadline)
                    .fontWeight(.bold)
            }

            if let img = imageApercu {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 120)
                    .cornerRadius(8)
                    .clipped()
            }

            HStack {
                Spacer()

                Button {
                    // Messagerie plus tard
                } label: {
                    Image(systemName: "bubble.right")
                        .font(.title2)
                        .foregroundColor(.black)
                }

                Spacer()

                Button("See more") {
                    // Voir plus plus tard
                }
                .font(.subheadline)
                .foregroundColor(.blue)

                Spacer()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
    }

    private var dateEnString: String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: date.start)
    }

    private var heureDebut: String {
        let f = DateFormatter()
        f.timeStyle = .short
        return f.string(from: date.start)
    }

    private var heureFin: String {
        let f = DateFormatter()
        f.timeStyle = .short
        return f.string(from: date.end)
    }
}

#Preview {
    ActiviteBoite(
        titre: "Soccer Game",
        sport: .soccer,
        infraNom: "Stade Olympique",
        date: DateInterval(start: Date(), duration: 5400),
        nbPlacesRestantes: 5,
        imageApercu: UIImage(systemName: "map")
    )
}


