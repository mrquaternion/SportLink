//
//  CarteActivite.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-13.
//

import SwiftUI

struct CarteActivite: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("⚽️ Soccer for everyone")
                        .font(.system(size: 22, weight: .bold, design: .default))
                    
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                        
                        Text("CEPSUM")
                            .font(.system(size: 13, weight: .medium))
                            
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 3, height: 3)
                        
                        Image(systemName: "calendar")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                        
                        Text("March 21, 3-5pm")
                            .font(.system(size: 13))
                    }
                    .foregroundColor(.gray)
                    
                    Text("11 places left")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.blue)
                        .padding(.top, 4)
                }
                
                Spacer()
                
                Text("Cancel")
                    .font(.system(size: 16, weight: .medium, design: .default))
                    .foregroundColor(.red)
            }
            .padding(.bottom, 4)
            
            HStack {
                Image("carte_dummy")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 270)
                    .cornerRadius(12)
                    .clipped()
                    
                Spacer()
                
                VStack {
                    Image(systemName: "bubble")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 36, height: 36)
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    Text("See more")
                        .font(.system(size: 12, weight: .regular, design: .default))
                        .foregroundColor(.blue)
                        
                }
            }
            .frame(height: 100)
            .padding(.top, 4)
                
        }
        .padding(24)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
    }
}

#Preview {
    CarteActivite()
}
