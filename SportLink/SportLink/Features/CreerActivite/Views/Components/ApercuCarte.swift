//
//  ApercuCarte.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-06.
//

import SwiftUI
import MapKit

struct ApercuCarte: View {
    @ObservedObject var vm: CreerActiviteVM
    @State private var imageApercu: UIImage?
    
    var body: some View {
        Group {
            if let image = vm.imageApercu {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                ProgressView()
                    .frame(height: 150)
            }
        }
        .onAppear { rafraichir() }
        .onReceive(vm.$infraChoisie) { _ in rafraichir() }
    }
    
    private func rafraichir() {
        imageApercu = nil
        vm.genererApercu()
        
        Task {
            imageApercu = vm.imageApercu
        }
    }
}

#Preview {
    ApercuCarte(vm: CreerActiviteVM(serviceActivites: ServiceActivites(), serviceEmplacements: DonneesEmplacementService()))
}
