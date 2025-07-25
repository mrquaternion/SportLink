//
//  AjoutPhotoProfilVue..swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-25.
//

import SwiftUI

struct AjoutPhotoProfilVue: View {
    @ObservedObject var authVM: AuthentificationVM
    let sportsChoisis: [String]
    let disponibilites: [String: [(Date, Date)]]

    @State private var image: UIImage?
    @State private var montrerPicker = false

    var body: some View {
        VStack(spacing: 30) {
            Text("Add a Profile Photo")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 40)

            // Cercle de prévisualisation
            Group {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 180, height: 180)
                        .clipShape(Circle())
                        .shadow(radius: 6)
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 180, height: 180)
                        .overlay(
                            Image(systemName: "person.crop.circle.badge.plus")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                        )
                }
            }
            .onTapGesture {
                montrerPicker = true
            }

            Text("Tap to choose a photo")
                .foregroundColor(.gray)

            Spacer()

            Button("CONTINUE") {
                // Enregistrer photo dans authVM ou passer à l'étape finale
            }
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red)
            .cornerRadius(30)
            .padding(.horizontal, 50)
            .padding(.bottom, 40)
        }
        .sheet(isPresented: $montrerPicker) {
            ImagePicker(image: $image)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AjoutPhotoProfilVue(
        authVM: AuthentificationVM(),
        sportsChoisis: ["soccer", "tennis"],
        disponibilites: [
            "Monday": [(Date(), Calendar.current.date(byAdding: .hour, value: 2, to: Date())!)],
            "Wednesday": [(Date(), Calendar.current.date(byAdding: .hour, value: 1, to: Date())!)]
        ]
    )
}
