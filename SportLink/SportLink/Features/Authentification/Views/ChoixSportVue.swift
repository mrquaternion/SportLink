//
//  ChoixSportVue.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-24.
//

import SwiftUI

struct ChoixSportVue: View {
    @State private var sportsChoisis: Set<String> = []
    @ObservedObject var authVM: AuthentificationVM

    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            Text("Choose Your Favorite Sports")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
                .padding(.top, 30)

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(Sport.allCases, id: \.self) { sport in
                        Button {
                            if sportsChoisis.contains(sport.nom) {
                                sportsChoisis.remove(sport.nom)
                            } else {
                                sportsChoisis.insert(sport.nom)
                            }
                        } label: {
                            HStack {
                                Image(systemName: sport.icone)
                                    .foregroundColor(.red)

                                Text(sport.nom.capitalized)
                                    .foregroundColor(.black) // 👈 texte du sport en noir

                                Spacer()

                                Image(systemName: sportsChoisis.contains(sport.nom) ? "checkmark.square.fill" : "square")
                                    .foregroundColor(.red)
                            }
                            .padding(.horizontal)
                        }

                        Divider()
                    }
                }
                .padding(.horizontal)
            }

            Spacer()
            

            Button(action: {
                // Continuer vers la suite de l'inscription
            }) {
                Text("CONTINUE")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(30)
                    .padding(.horizontal, 50)
            }
            .padding(.bottom, 40)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview("ChoixSportVue") {
    ChoixSportVue(authVM: AuthentificationVM())
}
