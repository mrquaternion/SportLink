//
//  TEST2.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-16.
//

import SwiftUI

struct TEST2: View {
    
    @StateObject var vueModele = EmplacementsVueModele()
    
    // Il y peut y avoir une répition de nom de parc dans la liste et c'est normal.
    // Ce qui devra être fait lors de l'affichage du marqueur c'est de sélectionner uniquemet
    // une seule instance de cet index puis pour le polygone, agglomérer
    var body: some View {
        Text("Nombre de parcs: \(vueModele.parcs.count)")
            .foregroundStyle(.blue)
        Text("Nombre d'infrastructures: \(vueModele.infrastructures.count)")
            .foregroundStyle(.blue)
        
        List(vueModele.parcs, id: \.index) { parc in
            VStack(alignment: .leading) {
                Text("\(parc.index) - \(parc.nom ?? "")")
                    .font(.headline)
                                
                Text("Sports liés : \(vueModele.sports(for: parc).map(\.rawValue).joined(separator: ", "))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    TEST2()
}
