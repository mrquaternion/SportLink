//
//  ApercuCarte.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-06.
//

import SwiftUI
import MapKit

struct ApercuCarte: View {
    @StateObject var vm = CreerActiviteVM()
    var infraChoisie: Infrastructure? = nil
    
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
        .onAppear {
            vm.infraChoisie = infraChoisie
            vm.genererApercu()
        }
        .onChange(of: infraChoisie?.id) {
            vm.imageApercu = nil
            vm.infraChoisie = infraChoisie
            vm.genererApercu()
        }
    }
}
