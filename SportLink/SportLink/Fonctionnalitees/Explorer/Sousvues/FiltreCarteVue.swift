//
//  FilterView.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-28.
//
import SwiftUI

struct FiltreCarteVue: View {
    private let options: [(Sport?, String)] = [(nil, "All")] + Sport.allCases.map { ($0, $0.rawValue.capitalized) }
    let espacementDroite: CGFloat = 12
    let cercleDim: CGFloat = 30
    private let couleurDeFond = Color(red: 0.97, green: 0.97, blue: 0.97)
    
    @Binding var filtresSelectionnes: Set<String>
    @State var afficherFiltrage: Bool = false
    
    var body: some View {
        ZStack(alignment: .trailing) {
            if afficherFiltrage {
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
                                    if let sport = sport {
                                        Image(systemName: sport.icone)
                                    }
                                    
                                    Text(nom)
                                        .padding(.vertical, 8)
                                        .fontWeight(filtresSelectionnes.contains(nom) ? .medium : .light)
                                    
                                }
                                .padding(.horizontal, 12)
                                .background(filtresSelectionnes.contains(nom) ? Color("CouleurParDefaut") : .white)
                                .foregroundColor(filtresSelectionnes.contains(nom) ? Color(red: 0.97, green: 0.97, blue: 0.97) : .primary)
                                .cornerRadius(14)
                                .shadow(color: .black.opacity(0.4), radius: 1.5, x: 0, y: 1)
                            }
                        }
                    }
                    .frame(height: 45)
                    .padding(.leading, 12)
                    .padding(.trailing, 45)
                    // Retirer le padding trailing d'ici
                }
                // Appliquer le masque et le padding au ScrollView
                .padding(.trailing, (cercleDim / 2) + espacementDroite)
                .transition(
                    .aPartirDe(position: CGPoint(x: 400, y: 0), masquePosition: (cercleDim / 2) + espacementDroite)
                )
            }
            
                
            HStack {
                Spacer()
                // Bouton de filtrage des parcs/infras
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 1)) {
                        afficherFiltrage.toggle()
                    }
                } label: {
                    Image("filter_map")
                        .resizable()
                        .scaledToFit()
                        .frame(width: cercleDim, height: cercleDim)
                        .padding(10)
                        .background(couleurDeFond)
                        .foregroundStyle(Color.black)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.4), radius: 1.5, x: 0, y: 1)
                }
                .buttonStyle(.plain)
                .padding(.trailing, espacementDroite)
                
            }
            .padding(.vertical, 8)
        }
    }
}

extension AnyTransition {
    static func aPartirDe(position: CGPoint, masquePosition: CGFloat = 0) -> AnyTransition {
        AnyTransition.modifier(
            active: OffsetEtMasque(offset: CGSize(width: position.x, height: position.y), opacite: 0, masquePosition: masquePosition),
            identity: OffsetEtMasque(offset: .zero, opacite: 1, masquePosition: masquePosition)
        )
    }
    
    private struct OffsetEtMasque: ViewModifier {
        let offset: CGSize
        let opacite: Double
        let masquePosition: CGFloat
        
        func body(content: Content) -> some View {
            content
                .offset(offset)
                .opacity(opacite)
                .mask(
                    HStack {
                        Rectangle()
                        if masquePosition > 0 {
                            Spacer()
                                .frame(width: masquePosition)
                        }
                    }
                )
        }
    }
}

#Preview {
    ZStack {
        FiltreCarteVue(filtresSelectionnes: .constant(["All"]))
    }
}
