//
//  MarqueurPersoVue.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-16.
//

import SwiftUI

struct MarqueurPersoVue: View {
    var body: some View {
        VStack {
            ZStack{
                Circle()
                    .fill(.white)
                    .frame(width: 67, height: 67)
                
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color(red: 0.4, green: 0.79, blue: 0.65), location: 0.0),
                                .init(color: Color(red: 0.04, green: 0.53, blue: 0.35), location: 1.0)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 55, height: 55)
                
                Image(systemName: "figure.run")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.white)
            }
            
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .frame(width: 10, height: 10)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -11)
                .padding(.bottom, 40)
            
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        MarqueurPersoVue()
    }
}
