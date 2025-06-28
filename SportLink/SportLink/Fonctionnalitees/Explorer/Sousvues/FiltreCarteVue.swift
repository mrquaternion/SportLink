//
//  FilterView.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-28.
//

import SwiftUI

struct FiltreCarteVue: View {
    private let options: [(Sport?, String)] = [(nil, "All")] + Sport.allCases.map { ($0, $0.rawValue.capitalized) }
    
    @Binding var filtresSelectionnes: Set<String>
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(options, id: \.1) { option in
                    let (sport, nom) = option
                    
                    Button {
                        if nom == "All" {
                            if filtresSelectionnes == ["All"] {
                                return
                            } else {
                                filtresSelectionnes = ["All"]
                            }
                        } else {
                            if filtresSelectionnes.contains(nom) {
                                filtresSelectionnes.remove(nom)
                                
                                if filtresSelectionnes.isEmpty {
                                    filtresSelectionnes.insert("All")
                                }
                            } else {
                                filtresSelectionnes.insert(nom)
                                filtresSelectionnes.remove("All")
                            }
                        }
                    } label: {
                        HStack {
                            if let sport = sport, let icone = sport.icone {
                                Image(systemName: icone.rawValue)
                            }
                            
                            Text(nom)
                                .padding(.vertical, 8)
                                .fontWeight(filtresSelectionnes.contains(nom) ? .medium : .light)
           
                        }
                        .padding(.horizontal, 12)
                        .background(filtresSelectionnes.contains(nom) ? Color("CouleurParDefaut") : .white)
                        .foregroundColor(filtresSelectionnes.contains(nom) ? .white : .primary)
                        .cornerRadius(14)
                        .shadow(color: .black.opacity(0.4), radius: 1.5, x: 0, y: 1)
                    }
                }
            }
            .frame(height: 45)
        }
        .frame(width: .infinity)
    }
}

#Preview {
    ZStack {
        FiltreCarteVue(filtresSelectionnes: .constant(["All"]))
    }
}
