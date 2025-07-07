//
//  SwiftUIView.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-20.
//

import SwiftUI

enum ModeAffichage {
    case liste
    case carte
}

struct BoutonSwitchExplorer: View {
    @Binding var modeAffichage: ModeAffichage
    
    let buttonWidth: CGFloat = 100
    let buttonHeight: CGFloat = 50

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: buttonHeight / 2)
                .fill(Color(red: 0.97, green: 0.97, blue: 0.97))
                .frame(width: buttonWidth * 2 + 30, height: buttonHeight)
                .shadow(color: .black.opacity(0.4), radius: 1.5, x: 0, y: 1)

            HStack {
                RoundedRectangle(cornerRadius: buttonHeight / 2)
                    .fill(Color("CouleurParDefaut"))
                    .frame(width: buttonWidth, height: buttonHeight - 10)
                    .offset(x: modeAffichage == .liste ? -buttonWidth/2 - 7.5 : buttonWidth/2 + 7.5)
                    .animation(.easeInOut(duration: 0.3), value: modeAffichage)
            }

            HStack(spacing: 15) {
                Button {
                    modeAffichage = .liste
                } label: {
                    Text("List")
                        .frame(width: buttonWidth, height: buttonHeight)
                        .foregroundColor(modeAffichage == .liste ? .white : .black)
                        .fontWeight(modeAffichage == .liste ? .semibold : .light)
                }

                Button {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        modeAffichage = .carte
                    }
                } label: {
                    Text("Map")
                        .frame(width: buttonWidth, height: buttonHeight)
                        .foregroundColor(modeAffichage == .carte ? .white : .black)
                        .fontWeight(modeAffichage == .carte ? .semibold : .light)
                }
            }
        }
        .frame(width: buttonWidth * 2 + 30, height: buttonHeight)
    }
}

#Preview {
    BoutonSwitchExplorer(modeAffichage: .constant(.carte))
}
