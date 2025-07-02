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
                Text("\(infra.sport[0].rawValue.capitalized) infrastructure")
                    .font(.title)
                
                Spacer()
            }
            .padding(.top)
            
            
            Divider()
                .overlay(Color.black)
            
            RecherchePOIVue(parc: parcParent)
                .padding(.top)
            
            Spacer()
        }.padding(25)
    }
}

#Preview {
    let service = DonneesEmplacementService()
    service.chargerDonnees()
    guard let infra = service.infrastructures.first,
          let parc = service.parcs.first else {
        return AnyView(EmptyView())
    }
    
    return InfraDetailVue(
        infra: infra,
        parc: parc,
        dateSelectionnee: .constant(Date())
    )
}

