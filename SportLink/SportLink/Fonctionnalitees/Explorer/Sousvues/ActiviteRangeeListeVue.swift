//
//  ActiviteRangeeVue.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-02.
//

import SwiftUI
import MapKit

struct ActiviteRangeeListeVue: View {
    var activite: Activite?
    @Binding var estFavoris: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Text(Sport.depuisNom(activite!.sport).emoji)
                .font(.system(size: 35))
            
            VStack {
                HStack {
                    Text(activite!.sport.capitalized)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button {
                        estFavoris.toggle()
                    } label: {
                        Image(systemName: estFavoris ? "bookmark" : "bookmark.fill")
                            .foregroundStyle(.yellow)
                    }

                }
                
                HStack {
                    Spacer()
                    
                    Text(formatterDate(activite!.date))
                }
            }
        }
        .padding(.horizontal, 20)
        .frame(width: 360, height: 65)
        .overlay(
            RoundedRectangle(cornerRadius: 13.52371)
                .stroke(Color(red: 0.89, green: 0.89, blue: 0.89), lineWidth: 0.7)
        )
    }
    
    func formatterDate(_ plage: PlageHoraire) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.locale = Locale(identifier: "en_US")

        let date = dateFormatter.string(from: plage.debut)
        let tempsDebut = timeFormatter.string(from: plage.debut)
        let tempsFin = timeFormatter.string(from: plage.fin)

        return "\(date), \(tempsDebut) - \(tempsFin)"
    }

}

#Preview {
    let mockUtilisateur1 = Utilisateur(
        nomUtilisateur: "mathias13",
        courriel: "",
        photoProfil: "",
        disponibilites: [:],
        sportsFavoris: [],
        activitesFavoris: [],
        partenairesRecents: []
    )
    
    let mockUtilisateur2 = Utilisateur(
        nomUtilisateur: "michel02",
        courriel: "",
        photoProfil: "",
        disponibilites: [:],
        sportsFavoris: [],
        activitesFavoris: [],
        partenairesRecents: []
    )
    
    ActiviteRangeeListeVue(activite: nil, estFavoris: .constant(false))
}
