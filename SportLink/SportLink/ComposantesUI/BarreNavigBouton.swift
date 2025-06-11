//
//  BarreNavigBoutton.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-10.
//

import SwiftUI

struct BarreNavigBouton: View {
    
    var nomOnglet : String
    var nomImage : String
    var estActif : Bool

    
    var body: some View {
        
        ZStack{
                Circle()
                    .fill(estActif ? Color("CouleurParDefaut") : Color.white)
                    .frame(width: 64, height: 64)
                
                
                VStack(alignment: .center, spacing: -2) {
                    Image(estActif ? "\(nomImage)_white" : "\(nomImage)_black")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 39, height: 39)

                    
                    Text(nomOnglet)
                        .font(Font.custom("Blinker", size: 10))
                        .multilineTextAlignment(.center)
                       
                } .foregroundColor(estActif ? .white : .black)
            
            
        }
    }
}

#Preview {
    BarreNavigBouton(nomOnglet: "Home", nomImage: "home", estActif: false)
}
