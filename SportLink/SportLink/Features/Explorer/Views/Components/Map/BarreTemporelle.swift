//
//  BarreTemporelleVue.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-26.
//

import SwiftUI

struct BarreTemporelle: View {
    @Binding var dateSelectionnee: Date
    private let couleurSelection: Color = Color("CouleurParDefaut").opacity(0.8)
    private let dateMin = Date.now // aujourd'hui
    private let dateMax = Calendar.current.date(byAdding: .weekOfYear, value: 4, to: Date())!

    var body: some View {
        HStack {
            VStack(spacing: 0) {
                Text("\(dateSelectionnee.formatted(.dateTime.month(.wide)))")
                
                Divider()
                    .overlay(Color.black)
                    .padding([.trailing, .leading], 30)
                    .padding([.top, .bottom], 8)
                
                HStack {
                    // Bouton de gauche
                    Button {
                        let nouvelleDate = Calendar.current.date(byAdding: .day, value: -7, to: dateSelectionnee)!
                        if nouvelleDate < dateMin {
                            // On ne bloque pas,on force à aujourd'hui
                            dateSelectionnee = dateMin
                        } else {
                            dateSelectionnee = nouvelleDate
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(Calendar.current.isDate(dateSelectionnee, equalTo: dateMin, toGranularity: .weekOfYear) || dateSelectionnee <= dateMin)
                    
                    Spacer()
                    
                    // Dates
                    ForEach(Date.datesDeLaSemaine(dateSelectionnee: dateSelectionnee), id: \.self) { jour in
                        VStack {
                            Text("\(Calendar.current.component(.day, from: jour))")
                                .font(.headline)
                                .frame(width: 30, height: 30, alignment: .center)
                                .foregroundStyle(getCouleurTexte(for: jour, couleurAlt1: .white))
                                .background(Calendar.current.isDate(jour, inSameDayAs: dateSelectionnee) ? couleurSelection : Color.clear)
                                .cornerRadius(20)
                            
                            Text(jour.formatted(.dateTime.weekday(.abbreviated)))
                                .font(.caption)
                                .foregroundStyle(getCouleurTexte(for: jour, couleurAlt1: couleurSelection))
                            
                            Circle()
                                .fill(Calendar.current.isDate(jour, inSameDayAs: dateSelectionnee) ? couleurSelection : Color.clear)
                                .frame(width: 5, height: 5, alignment: .center)
                        }
                        .padding([.trailing, .leading], 3)
                        .padding(.top, 6)
                        .onTapGesture {
                            dateSelectionnee = jour
                        }
                        .disabled(Calendar.current.startOfDay(for: dateMin) > Calendar.current.startOfDay(for: jour))
                    }
                    
                    Spacer()
                    
                    // Bouton de droite
                    Button {
                        let nouvelleDate = Calendar.current.date(byAdding: .day, value: 7, to: dateSelectionnee)!
                        if nouvelleDate > dateMax {
                            dateSelectionnee = dateMax
                        } else {
                            dateSelectionnee = nouvelleDate
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                    .disabled(Calendar.current.isDate(dateSelectionnee, equalTo: dateMax, toGranularity: .weekOfYear) || dateSelectionnee >= dateMax)
                }
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if abs(value.translation.width) > 50 { // seuil pour éviter les petits gestes
                        if value.translation.width < 0 {
                            // Glissé vers la gauche : semaine suivante
                            let nouvelleDate = Calendar.current.date(byAdding: .day, value: 7, to: dateSelectionnee)!
                            withAnimation {
                                dateSelectionnee = min(nouvelleDate, dateMax)
                            }
                        } else {
                            // Glissé vers la droite : semaine précédente
                            let nouvelleDate = Calendar.current.date(byAdding: .day, value: -7, to: dateSelectionnee)!
                            withAnimation {
                                dateSelectionnee = max(nouvelleDate, dateMin)
                            }
                        }
                    }
                }
        )

    }
}

extension BarreTemporelle {
    func getCouleurTexte(for jour: Date, couleurAlt1: Color) -> Color {
        if Calendar.current.startOfDay(for: dateMin) > Calendar.current.startOfDay(for: jour) {
            return .gray
        } else {
            return Calendar.current.isDate(jour, inSameDayAs: dateSelectionnee) ? couleurAlt1 : .black
        }
    }
}

extension Date {
    static func datesDeLaSemaine(dateSelectionnee: Date) -> [Date] { // source : https://www.reddit.com/r/SwiftUI/comments/196kgol/need_help_for_a_custom_date_picker_in_swiftui/
        var dates = [Date]()
        let calendrier = Calendar.current
        let jourDeLaSemaine = calendrier.component(.weekday, from: dateSelectionnee)
        
        if let debutSemaine = calendrier.date(byAdding: .day, value: -(jourDeLaSemaine - 1), to: dateSelectionnee) {
            for i in 0..<7 {
                if let jour = calendrier.date(byAdding: .day, value: i, to: debutSemaine) {
                    dates.append(jour)
                }
            }
        }
        return dates
    }
}

#Preview {
    BarreTemporelle(dateSelectionnee: .constant(Date(timeIntervalSinceNow: 0)))
}
