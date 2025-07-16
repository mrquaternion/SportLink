//
//  SeeMoreVueHosted.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-15.
//

import SwiftUI

struct SeeMoreVueHosted: View {
    let titre: String
    let sport: Sport
    let debut: Date
    let fin: Date
    @Environment(\.dismiss) var dismiss
    
    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.locale = Locale(identifier: "fr_CA") // ou "en_CA" si tu veux anglais
        f.dateStyle = .full  // Ex. : "mardi 16 juillet 2025"
        f.timeStyle = .none
        return f
    }
    
    private var formatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
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
                        // Action vers une autre page plus tard
                    }) {
                        Image(systemName: "square.and.pencil")
                            .font(.title2)
                            .padding()
                    }
                }

                Text(titre)
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                
                HStack(spacing: 8) {
                    Image(systemName: sport.icone)
                        .foregroundColor(.red)
                        .font(.title3)
                    
                    Text(sport.nom.capitalized)
                        .font(.title3)
                        .fontWeight(.medium)
                }
                .padding(.horizontal)
                .padding(.top, 4)
                
                Text("Date : \(dateFormatter.string(from: debut))")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                Text("Plage horaire : \(formatter.string(from: debut)) - \(formatter.string(from: fin))")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding(.horizontal)

                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        SeeMoreVueHosted(
            titre: "Tournoi de soccer",
            sport: .soccer,
            debut: Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date())!,
            fin: Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date())!
        )
    }
}
