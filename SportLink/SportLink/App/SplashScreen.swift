//
//  SplashScreen.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-27.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Color("CouleurParDefaut").ignoresSafeArea(.all)
            
            VStack {
                Image("AppIconSansArrierePlan")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 230)
                    .padding(.bottom, 5)
                
                Text("SPORTLINK")
                    .font(.system(size: 30, weight: .bold, design: .default))
                    .foregroundStyle(Color(.white))

            }
        }
    }
}

#Preview {
    SplashScreen()
}
