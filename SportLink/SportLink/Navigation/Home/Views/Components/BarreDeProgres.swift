//
//  BarreDeProgres.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-22.
//

import SwiftUI

struct BarreDeProgres: View {
    // MARK: Variables et propriétés calculées
    @Binding var nombreDePoints: Double
    @Binding var seuilDuNiveau: Double
    @State private var progres: Double = 0.0
    let basePhase: CGFloat = 1
    let sport: Sport
    let epaisseurBarreGrise: CGFloat
    let longueurDash: CGFloat
    let dashGap: CGFloat
    let hauteurRectangleOverlay: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: basePhase)
                .stroke(style: .init(lineWidth: epaisseurBarreGrise, lineCap: .round, lineJoin: .round, dash: [longueurDash, dashGap]))
                .fill(Color(.systemGray4))
                .rotationEffect(.degrees(-90))
            
            Circle()
                .trim(from: 0.0, to: progres)
                .stroke(style: .init(lineWidth: epaisseurBarreGrise * 2.2, lineCap: .round, lineJoin: .round))
                .fill(Color.red.gradient)
                .rotationEffect(.degrees(-90))
        }
        .overlay(
            Rectangle()
                .opacity(0)
                .frame(width: 20, height: hauteurRectangleOverlay)
                .overlay(alignment: .top) {
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 50 * hauteurRectangleOverlay / 400,
                                   height: 50 * hauteurRectangleOverlay / 400)
                            
                        
                        Image(systemName: sport.icone)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30 * hauteurRectangleOverlay / 400,
                                   height: 30 * hauteurRectangleOverlay / 400)
                             // hardcoded
                            .foregroundStyle(.black)  
                    }
                    .rotationEffect(.degrees(90))
                }
                .rotationEffect(.degrees(progres * 360))
        )
        
        .onAppear {
            withAnimation(.smooth(duration: 1.5)) {
                progres = conversionPhase(baseDuNiveau: seuilDuNiveau, valeur: nombreDePoints)
            }
        }
    }
    
    private func conversionPhase(baseDuNiveau: Double, valeur: Double) -> CGFloat {
        return CGFloat(valeur * basePhase) / baseDuNiveau
    }
}

// MARK: Preview
#Preview {
    BarreDeProgres(nombreDePoints: .constant(70.0), seuilDuNiveau: .constant(100.0), sport: .soccer, epaisseurBarreGrise: 10, longueurDash: 4, dashGap: 18, hauteurRectangleOverlay: 400)
}
