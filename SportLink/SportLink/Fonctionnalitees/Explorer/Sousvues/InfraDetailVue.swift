//
//  sheetVue.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-25.
//

import SwiftUI

struct InfraDetailVue: View {
    var infra: Infrastructure
    var parcParent: Parc
    @Binding var dateSelectionnee: Date
    
    init(infra: Infrastructure, parc: Parc, dateSelectionnee: Binding<Date>) {
        self.infra = infra
        self.parcParent = parc
        self._dateSelectionnee = dateSelectionnee
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Field for \(infra.sport[0].rawValue)")
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
            
            RecherchePOIVue(parc: parcParent)
                .padding(.top)
            
            Spacer()
        }.padding()
    }
}

#Preview {
    InfraDetailVue(infra: DonneesEmplacementService().infrastructures.first!,
                   parc: DonneesEmplacementService().parcs.first!,
                   dateSelectionnee: .constant(Date(timeIntervalSinceNow: 0)))
}

