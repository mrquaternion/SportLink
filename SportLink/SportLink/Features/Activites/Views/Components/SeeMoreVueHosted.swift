//
//  SeeMoreVueHosted.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-15.
//

import SwiftUI

struct SeeMoreVueHosted: View {
    let titre: String
    let sport: Sport
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding()
                    }

                    Spacer()

                    Button(action: {
                        // Action vers une autre page plus tard
                    }) {
                        Image(systemName: "square.and.pencil")
                            .font(.title2)
                            .padding()
                    }
                }

                Text(titre)
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                
                HStack(spacing: 8) {
                    Image(systemName: sport.icone)
                        .foregroundColor(.red)
                        .font(.title3)
                    
                    Text(sport.nom.capitalized)
                        .font(.title3)
                        .fontWeight(.medium)
                }
                .padding(.horizontal)
                .padding(.top, 4)

                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        SeeMoreVueHosted(titre: "Tournoi de soccer", sport: .soccer)
    }
}
