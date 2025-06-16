//
//  SwiftUIView.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-15.
//

import SwiftUI

class MarqueursVueModele: ObservableObject {
    @Published var infrastructures: [Infrastructure] = []
    @Published var parcs: [Parc] = []
    
    init() {
        chargerDonnees()
    }
    
    private func chargerDonnees() {
        do {
            // Parsing des deux fichiers JSON
            let collectionInfra: Collection = try Bundle.main.decodeJSON("terrain_sport_ext")
            let objetsInfra = collectionInfra.objets.filter {
                let type = $0.proprietes.typeInfra
                return type == "Sportif" || type == "Récréatif" || type == "Loisirs et détente"
            }
            
            let parcIds = Set(objetsInfra.compactMap { $0.proprietes.indexParcDeInfra })
            
            let collectionParc: Collection = try Bundle.main.decodeJSON("espace_vert")
            let objetsParc = collectionParc.objets.filter {
                guard let id = $0.proprietes.indexParcDeParc else { return false }
                return parcIds.contains(id)
            }
            
            // Construction des objets Infrastructure
            self.infrastructures = objetsInfra.compactMap { objet in
                guard
                    let id = objet.proprietes.idInfra,
                    let indexParc = objet.proprietes.indexParcDeInfra,
                    let lat = objet.geometrie.point?[0],
                    let lon = objet.geometrie.point?[1],
                    let sport = obtenirSport(chaine: objet.proprietes.nomInfra!),
                    !sport.isEmpty // Retirer tous les infrastructres dont la liste de Sport est vide (en d'autres mots,
                                   // c'est le nomInfra ne contient pas un sport parmi `enum` Sport)
                else {
                    return nil
                }
         
                
                return Infrastructure(
                    id: id,
                    indexParc: indexParc,
                    latitude: lat,
                    longitude: lon,
                    sport: sport
                )
            }
            
            // Construction des objets Parc
            self.parcs = objetsParc.compactMap { objet in
                let index = objet.proprietes.indexParcDeParc!
                
                let typeParc = objet.proprietes.typeParc ?? ""
                let lien = objet.proprietes.lien ?? ""
                let nomParc = objet.proprietes.nomParc ?? ""
                let nom = "\(typeParc) \(lien) \(nomParc)"
                
                let limites: Parc.Geometrie
                if let poly = objet.geometrie.polygone {
                    limites = .polygon(poly)
                } else if let multi = objet.geometrie.multiPolygone {
                    limites = .multiPolygon(multi)
                } else {
                    return nil
                }
                
                let idsInfra = infrastructures // On veut l'ID des infrastructures qui font parti du parc traité
                    .filter { $0.indexParc == index }
                    .compactMap { $0.id }
                
                return Parc(
                    index: index,
                    nom: nom,
                    limites: limites,
                    idsInfra: idsInfra,
                    heuresOuvertures: nil
                )
            }
        } catch {
            print("Erreur")
        }
    }
    
    private func obtenirSport(chaine: String) -> [Sport]? {
        return Sport.allCases.filter { sport in
            chaine.localizedCaseInsensitiveContains(sport.rawValue)
        }
    }
}

struct ContentView: View {
    @StateObject private var vueModele = MarqueursVueModele()
    
    var body: some View {
        List(vueModele.parcs, id: \.index) { parc in
            Text("""
                \(parc.index) -
                \(parc.nom ?? "") - 
                \(parc.idsInfra)
            """)
        }
        .onAppear()
    }
}

#Preview {
    ContentView()
}
