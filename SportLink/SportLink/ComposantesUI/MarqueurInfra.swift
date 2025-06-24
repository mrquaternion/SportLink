//
//  SwiftUIView.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-20.
//

import SwiftUI

enum IconeSport: String {
    case soccer = "soccerball.circle.fill"
    case basketball = "basketball.circle.fill"
    case volleyball = "volleyball.circle.fill"
    case tennis = "tennis.racket.circle.fill"
    case baseball = "baseball.circle.fill"
    case rugby = "rugbyball.circle.fill"
    case football = "american.football.circle.fill"
    case pingpong = "figure.table.tennis.circle.fill"
    case badminton = "figure.badminton.circle.fill"
    case ultimateFrisbee = "figure.disc.sports.circle.fill"
    case petanque = "target"
}

struct MarqueurInfra: View {
    @State var estActive: Bool
    
    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle()) 
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        estActive = false
                    }
                }
            

            Button {
                withAnimation(.smooth(duration: 0.5)) {
                    estActive = true
                }
            } label: {
                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: estActive ? 10 : 100)
                        .fill(Color.white)
                        .frame(width: 100, height: 100)
                        .scaleEffect(estActive ? 2.5 : 1, anchor: .bottom)
                        .overlay {
                            VStack(spacing: 10) {
                                if estActive {
                                    ForEach(0..<2, id: \.self) { _ in
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.clear)
                                            .stroke(Color("CouleurParDefaut"), lineWidth: 1)
                                            .frame(width: 210, height: 55)
                                            .transition(
                                                .asymmetric(
                                                    insertion: .scale.animation(.smooth(duration: 0.5)),
                                                    removal: .scale.animation(.easeInOut(duration: 0.1))
                                                )
                                                
                                            )
                                    }
                                } else {
                                    Image(systemName: IconeSport.football.rawValue)
                                        .resizable()
                                        .foregroundStyle(Color("CouleurParDefaut"))
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .transition(
                                            .opacity.animation(.easeInOut(duration: 0.1))
                                        )
                                        .padding(.top, 50)
                                }
                            }
                            .padding(.bottom, 50)
                        }
                    
                    Image(systemName: "triangle.fill")
                        .resizable()
                        .foregroundStyle(.white)
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .rotationEffect(Angle(degrees: 180))
                        .offset(y: -5)
                        .padding(.bottom, 40)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        MarqueurInfra(estActive: false)
    }
}
