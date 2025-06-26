//
//  sheetVue.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-25.
//

import SwiftUI

struct InfraDetailVue: View {
    var infra: Infrastructure
    @Binding var dateSelectionnee: Date
    
    init(infra: Infrastructure, dateSelectionnee: Binding<Date>) {
        self.infra = infra
        self._dateSelectionnee = dateSelectionnee
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Terrain de \(infra.sport[0].rawValue)")
                    .font(.title)
                
                Spacer()
                
                Button {
                    // Code
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
    InfraDetailVue(infra: DonneesEmplacementService().infrastructures.first!,
                   dateSelectionnee: .constant(Date(timeIntervalSinceNow: 0)))
}

