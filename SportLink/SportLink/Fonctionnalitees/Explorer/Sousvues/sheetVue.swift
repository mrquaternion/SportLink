//
//  sheetVue.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-25.
//

import SwiftUI

struct sheetVue: View {
    var infra: Infrastructure
    
    init(infra: Infrastructure) {
        self.infra = infra
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Terrain de \(infra.sport[0].rawValue)")
                    .font(.title)
                
                Spacer()
                
                Button {
                    // Toggle
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(.black)
                }

            }.padding(.top)
            
            Divider()
                .overlay(Color.black)
            
            Spacer()
        }.padding()
    }
}

#Preview {
    sheetVue(infra: DonneesEmplacementService().infrastructures.first!)
}
