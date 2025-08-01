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
    let basePhase: CGFloat = 0.32
    let sport: Sport
    let epaisseurBarre: CGFloat
    let ajustement: (x: CGFloat, y: CGFloat)
    
    private var tailleEmoji: CGFloat {
       return epaisseurBarre * 1.3
   }
    
    var body: some View {
        GeometryReader { geometrie in
            let taille = min(geometrie.size.width, geometrie.size.height)
            let centre = CGPoint(x: geometrie.size.width/2, y: geometrie.size.height/2)
            let rayon = taille/2 - epaisseurBarre/2
            let angleFin = Angle(degrees: basePhase * 360.0 - 90.0)
            let dx = cos(angleFin.radians) * rayon
            let dy = sin(angleFin.radians) * rayon
            
            VStack {
                ZStack {
                    Circle()
                        .trim(from: 0.0, to: basePhase)
                        .stroke(style: .init(lineWidth: epaisseurBarre, lineCap: .round, lineJoin: .round))
                        .fill(Color(.systemGray4))
                        .rotationEffect(.degrees(-90))
                        
                    
                    Circle()
                        .trim(from: 0.0, to: progres)
                        .stroke(style: .init(lineWidth: epaisseurBarre, lineCap: .round, lineJoin: .round))
                        .fill(Color(.systemGreen))
                        .rotationEffect(.degrees(-90))
                    
                    Text(sport.emoji)
                        .font(.system(size: tailleEmoji))
                        .position(x: centre.x + dx + ajustement.x, y: centre.y + dy + ajustement.y)
                }
            }
            .onAppear {
                withAnimation(.smooth(duration: 1)) {
                    progres = conversionPhase(baseDuNiveau: seuilDuNiveau, valeur: nombreDePoints)
                }
            }
        }
    }
    
    private func conversionPhase(baseDuNiveau: Double, valeur: Double) -> CGFloat {
        return CGFloat(valeur * basePhase) / baseDuNiveau
    }
}


// MARK: Preview
#Preview {
    BarreDeProgres(nombreDePoints: .constant(50.0), seuilDuNiveau: .constant(100.0), sport: .soccer, epaisseurBarre: 28, ajustement: (x: 15, y: 15))
}
