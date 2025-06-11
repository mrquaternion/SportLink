//
//  EcranDemarrage.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-09.
//

import SwiftUI

struct VueEcranDemarrage: View {
    var body: some View {
        ZStack {
            Color("CouleurParDefaut").ignoresSafeArea(.all)
            
            VStack {
                Image("AppIconSansArrierePlan")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250)
                    .padding(.bottom, 5)
                
                Text("SPORTLINK")
                    .font(.system(size: 30, weight: .bold, design: .default))
                    .foregroundStyle(Color(red: 40/255, green: 40/255, blue: 40/255))

            }
        }
    }
}

#Preview {
    VueEcranDemarrage()
}
