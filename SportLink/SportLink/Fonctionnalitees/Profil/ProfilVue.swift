//
//  ProfilVue.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-06-27.
//

import SwiftUI

struct ProfilVue: View {
    @State private var username: String = "juando12"
    @State private var email: String = "juan.dominguez12@gmail.com"
    @State private var password: String = "********"
    
    @State private var availability: [String: (Bool, Bool)] = [
        "MON": (false, false),
        "TUE": (false, false),
        "WED": (false, false),
        "THU": (false, false),
        "FRI": (false, false),
        "SAT": (false, false),
        "SUN": (false, false)
    ]
    
    let preferences = ["Soccer", "Badminton", "Volleyball"]
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // Rectangle rouge
            Rectangle()
                .fill(Color.red)
                .frame(height: 125)
                .ignoresSafeArea(edges: .top)
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .background(Color.white)
                        .clipShape(Circle())
                   

                    
                    HStack {
                        Text(username)
                            .font(.title)
                            .bold()
                        Image(systemName: "pencil")
                    }
                    
                    Divider()
                    
                    Group {
                        Text("My information")
                            .font(.headline)
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text("My availabilities (a partir d'ici c'est trash, ne pas tenir compte")
                            .font(.headline)
                        availabilityGrid
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text("My preferences")
                            .font(.headline)
                        HStack {
                            ForEach(preferences, id: \.self) { pref in
                                Text(pref)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        // Action Log out
                    }) {
                        Text("Log out")
                            .foregroundColor(.red)
                            .bold()
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .padding(.bottom, 40)
            }
        }
    }
    
    var availabilityGrid: some View {
        VStack(alignment: .leading) {
            ForEach(["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"], id: \.self) { day in
                HStack {
                    Text(day)
                        .frame(width: 50, alignment: .leading)
                    Toggle("AM", isOn: Binding(
                        get: { availability[day]?.0 ?? false },
                        set: { availability[day]?.0 = $0 }
                    ))
                    .labelsHidden()
                    Toggle("PM", isOn: Binding(
                        get: { availability[day]?.1 ?? false },
                        set: { availability[day]?.1 = $0 }
                    ))
                    .labelsHidden()
                }
            }
        }
    }
}
#Preview {
    ProfilVue()
}

