//
//  SwiftUIView.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-09.
//

import SwiftUI

struct Vague: Shape {
        
    var cstMaxX = 0.75
    var cstMaxY = 1.25

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .zero)
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        
        path.addCurve(to: CGPoint(x: rect.minX, y: rect.maxY),
                      control1: CGPoint(x: rect.maxX * cstMaxX, y: rect.maxY * cstMaxX),
                      control2: CGPoint(x: rect.maxX * 0.25, y: rect.maxY * cstMaxY))
        
        path.closeSubpath()
        
        return path
    }
}

struct Vague_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ZStack(alignment: .top) {
                Vague(cstMaxX: 0.8, cstMaxY: 1.4)
                    .fill(Color("CouleurRougeClaire"))
                    .frame(height: 235)
                    
                Vague(cstMaxX: 0.8, cstMaxY: 1.35)
                    .fill(Color("CouleurRougeMedium"))
                    .frame(height: 205)
                    .shadow(color: Color.black.opacity(0.6), radius: 10, y: -6)
                
                Vague()
                    .fill(Color("CouleurParDefaut"))
                    .frame(height: 170)
                    .shadow(color: Color.black.opacity(0.8), radius: 10, y: -4)
                
            }
            
            Spacer()
            
            Text("Welcome to SportLink!")
                .font(.system(size: 30, weight: .bold, design: .default))
                .foregroundColor(Color(red: 40/255, green: 40/255, blue: 40/255))
                .padding(.bottom, 5)
            
            Text("Discover new sports")
                .font(.system(size: 13, weight: .medium, design: .default))
                .foregroundColor(Color(red: 140/255, green: 140/255, blue: 140/255))
            
            Spacer()

        }.ignoresSafeArea(.all)
    }
}
