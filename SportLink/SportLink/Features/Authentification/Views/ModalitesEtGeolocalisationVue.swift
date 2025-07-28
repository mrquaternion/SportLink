//
//  ModalitesEtGeolocalisationVue.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-26.
//

import SwiftUI

struct ModalitesEtGeolocalisationVue: View {
    @ObservedObject var vm: InscriptionVM
    @Binding var etape: [EtapeSupplementaireInscription]
    let onComplete: () -> Void
    
    var body: some View {
        VStack {
            Text("Registration Complete!")
                .font(.title)
                .padding()
            
            Text("Welcome to SportLink!")
                .font(.headline)
                .padding()
            
            Spacer()
            
            Button("Get Started") {
                // Save final data, then complete the flow
                vm.enregistrementProfil()
                onComplete()
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
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ModalitesEtGeolocalisationVue(vm: InscriptionVM(), etape: .constant([.geolocalisation]), onComplete: {})
}
