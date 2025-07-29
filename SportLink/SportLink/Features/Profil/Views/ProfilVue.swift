//
//  ProfilVue.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-06-27.
//

import SwiftUI

struct ProfilVue: View {
    @State private var image: UIImage? = nil
    @State private var montrerImagePicker = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Your Profile")
                .font(.largeTitle.bold())
                .padding(.top, 40)

            Button(action: {
                montrerImagePicker = true
            }) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 130, height: 130)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        .shadow(radius: 5)
                } else {
                    ZStack {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 130, height: 130)
                        Image(systemName: "camera.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                    }
                }
            }
            .sheet(isPresented: $montrerImagePicker) {
                ImagePicker(image: $image)
            }

            Text("Michel Lamothe") // Ce nom devrait venir d’un ViewModel ou utilisateur connecté
                .font(.title2)

            Spacer()
        }
        .padding()
    }
}
#Preview {
    ProfilVue()
}

