//
//  AjoutPhotoProfilVue..swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-25.
//

import SwiftUI

struct AjoutPhotoProfilVue: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: InscriptionVM
    @Binding var etape: [EtapeSupplementaireInscription]

    @State private var image: UIImage?
    @State private var montrerPicker = false

    var body: some View {
        VStack(spacing: 60) {
            enTete

            // Cercle de prévisualisation
            VStack(spacing: 24) {
                Group {
                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 180, height: 180)
                            .clipShape(Circle())
                            
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

                Text("tap to choose a photo".localizedFirstCapitalized)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .sheet(isPresented: $montrerPicker) {
            ImagePicker(image: $image)
        }
        .navigationBarBackButtonHidden(true)
        .safeAreaInset(edge: .bottom) {
            boutonContinuer
        }
    }
    
    @ViewBuilder
    private var enTete: some View {
        VStack {
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .tint(.primary)
                }
                .frame(height: 30)
                .padding()
                Spacer()
            }
            HStack {
                Text("add a profile photo".localizedCapitalized)
                    .font(.title.weight(.bold))
                    .padding(.horizontal)
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private var boutonContinuer: some View {
        Button("continue".localizedCapitalized) {
            // Enregistrer photo dans authVM ou passer à l'étape finale
            vm.photo = image
            etape.append(.geolocalisation)
        }
        .font(.headline)
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.red)
        .foregroundColor(.white)
        .cornerRadius(25)
        .padding()
    }
}

#Preview {
    AjoutPhotoProfilVue(vm: InscriptionVM(), etape: .constant([.photoProfil]))
}
