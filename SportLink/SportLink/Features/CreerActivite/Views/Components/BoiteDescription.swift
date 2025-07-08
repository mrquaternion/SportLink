//
//  BoiteDescription.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-07.
//



import SwiftUI

struct BoiteDescription: View {
    @Binding var description: String
    let nombreMotsMax: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Description")
                .font(.headline)
                .foregroundColor(.black)
            
            Text("\(nombreMotsMax) words maximum")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 4)
            
            TextEditor(text: $description)
                .frame(minHeight: 100)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: Color.gray.opacity(0.1), radius: 2, x: 0, y: 1)
                )
                .onChange(of: description) {
                    limiterNombreMots(nombreMotsMax)
                }

        }
        .padding(.horizontal)
    }

    private func limiterNombreMots(_ maxMots: Int) {
        let mots = description.split { $0.isWhitespace || $0.isNewline }
        if mots.count > maxMots {
            let motsLimites = mots.prefix(maxMots)
            description = motsLimites.joined(separator: " ")
        }
    }
}

#Preview {
    BoiteDescription(description: .constant(""), nombreMotsMax: 50)
}

