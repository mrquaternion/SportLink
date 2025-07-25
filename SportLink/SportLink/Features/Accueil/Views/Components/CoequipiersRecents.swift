//
//  CoequipiersRecents.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-23.
//

import SwiftUI
import VTabView

struct CoequipiersInfo: Identifiable {
    var id = UUID().uuidString
    var nbPartiesJouees: Int
    var prenom: String
    var dernierSportJoue: Sport
}

struct CoequipiersRecents: View {
    let coequipiers: [CoequipiersInfo] = [
        .init(nbPartiesJouees: 15, prenom: "Alexandre", dernierSportJoue: .soccer),
        .init(nbPartiesJouees: 8,  prenom: "Sam",       dernierSportJoue: .basketball),
        .init(nbPartiesJouees: 5,  prenom: "Jess",      dernierSportJoue: .tennis),
        .init(nbPartiesJouees: 3,  prenom: "Allison",   dernierSportJoue: .pingpong),
        .init(nbPartiesJouees: 3,  prenom: "Matthew",   dernierSportJoue: .tennis),
        .init(nbPartiesJouees: 1,  prenom: "Josh",      dernierSportJoue: .volleyball),
    ]

    let lignesParPage = 5
    @State private var page = 0

    var pagesTotales: Int {
        (coequipiers.count + lignesParPage - 1) / lignesParPage
    }

    var body: some View {
        VStack(spacing: 16) {
            titre

            VStack(spacing: 10) {
                VStack(spacing: 0) {
                    enTeteBoite
                    carrousel
                }
                .background(Color.white)
                .mask(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.15), radius: 2)

                // Pager buttons
                boutonUpDown
            }
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private var titre: some View {
        HStack {
            Text("Most recent teammates")
                .font(.title2.weight(.semibold))
            Spacer()
            Image(systemName: "info.circle")
                .foregroundStyle(.secondary)
                .padding(.top, 3)
                .onTapGesture {
                    // Afficher message info
                }
        }
    }
    
    @ViewBuilder
    private var enTeteBoite: some View {
        // Catégories
        VStack(alignment: .leading) {
            HStack {
                Text("#").frame(width: 65)
                Text("Player").frame(width: 110)
                Text("Sport played").frame(width: 140)
                Text("")
            }
            Divider()
        }
        .font(.callout.weight(.semibold))
        .padding(.top)
    }

    @ViewBuilder
    private var carrousel: some View {
        CarouselView(pageCount: pagesTotales, currentIndex: $page) {
            ForEach(0..<pagesTotales, id: \.self) { pageIndex in
                VStack(spacing: 0) {
                    ForEach(pageIndex * lignesParPage ..< min((pageIndex + 1) * lignesParPage, coequipiers.count), id: \.self) { i in
                        LigneCoequipier(info: coequipiers[i])
                    }
                    // fill empty rows
                    let filled = min(lignesParPage, coequipiers.count - pageIndex * lignesParPage)
                    ForEach(0..<lignesParPage - filled, id: \.self) { _ in
                        HStack(spacing: 0) {
                            Color.clear.frame(width: 60, height: 70)
                            Color.clear.frame(width: 130, height: 70)
                            Color.clear.frame(width: 110, height: 70)
                            Color.clear.frame(width: 30, height: 70)
                        }
                    }
                }
                .frame(width: 360, height: 350)
            }
        }
        .frame(height: 350)
    }
    
    @ViewBuilder
    private var boutonUpDown: some View {
        HStack(spacing: 22) {
            Button {
                withAnimation { page = max(page - 1, 0) }
            } label: { Image(systemName: "chevron.left") }.disabled(page == 0)
            
            Text("\(page + 1) / \(pagesTotales)")
                .font(.headline)
            
            Button {
                withAnimation { page = min(page + 1, pagesTotales - 1) }
            } label: { Image(systemName: "chevron.right") }.disabled(page == pagesTotales - 1)
        }
        .font(.system(size: 22))
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .tint(Color("CouleurParDefaut"))
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.15), radius: 2)
        .padding(.leading, 8)
    }
}

struct LigneCoequipier: View {
    var info: CoequipiersInfo

    @State private var estAppuyee = false
    
    var body: some View {
        HStack(spacing: 0) {
            Text("\(info.nbPartiesJouees)")
                .frame(width: 60, height: 70)
                .font(.system(size: 16))
                
            HStack {
                Image(info.prenom)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 26, height: 26)
                    .clipShape(.circle)
                Text(info.prenom)
                    .font(.system(size: 14))
            }
            .frame(width: 130, height: 70, alignment: .leading)
            .padding(.leading)
            
            Text(info.dernierSportJoue.nom.capitalized)
                .frame(width: 110, height: 70)
                .font(.system(size: 15))
            
            Image(systemName: "chevron.right")
                .frame(width: 30, height: 70, alignment: .trailing)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .background(estAppuyee ? Color(.systemGray6) : Color.white)
        .onLongPressGesture(
            minimumDuration: 0,
            maximumDistance: .infinity,
            pressing: { pressing in     
                withAnimation(.easeOut(duration: 0.2)) {
                    estAppuyee = pressing
                }
            },
            perform: {
                print("Tapped \(info.prenom)")
            }
        )
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CoequipiersRecents()
        
}

struct CarouselView<Content: View>: View {
    let pageCount: Int
    @Binding var currentIndex: Int
    @ViewBuilder let content: () -> Content

    @GestureState private var translation: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            LazyHStack(spacing: 0) {
                content()
                    .frame(width: geometry.size.width)
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .offset(x: -CGFloat(currentIndex) * geometry.size.width)
            .offset(x: translation)
            .animation(.spring(duration: 0.7), value: currentIndex)
            .animation(.spring(duration: 0.7), value: translation)
        }
    }
}
