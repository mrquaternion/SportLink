//
//  SwiftUIView.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-15.
//

import SwiftUI
import MapKit

class EmplacementsVueModele: ObservableObject {
    @Published var infrastructures: [Infrastructure] = []
    @Published var parcs: [Parc] = []
    
    init() {
        let (infras, parcs) = chargerDonnees()
        self.infrastructures = infras
        self.parcs = parcs
    }
    
    private func chargerDonnees() -> ([Infrastructure], [Parc]) {
        do {
            // Parsing des deux fichiers JSON
            let collectionInfra = try ChargeurJSON.chargementCollection(from: "terrain_sport_ext")
            print("collectionInfra chargée: \(collectionInfra.objets.count) objets") // Affiche les erreurs si le parsing ne s'effectue pas correctement
            let collectionParc = try ChargeurJSON.chargementCollection(from: "espace_vert")
            print("collectionParc chargée: \(collectionParc.objets.count) objets") // Affiche les erreurs si le parsing ne s'effectue pas correctement
            
            let objetsInfra = collectionInfra.objets.filter {
                let type = $0.proprietes.typeInfra
                return type == "Sportif" ||
                       type == "Récréatif" ||
                       type == "Loisirs et détente"
            }
            
            let parcIds = Set(objetsInfra.compactMap { $0.proprietes.indexParcDeInfra })
            let objetsParc = collectionParc.objets.filter {
                guard let id = $0.proprietes.indexParcDeParc else { return false }
                return parcIds.contains(id)
            }
            
            // Construction des objets Infrastructure
            let infrastructures: [Infrastructure] = objetsInfra.compactMap { objet in
                guard
                    let id = objet.proprietes.idInfra,
                    let indexParc = objet.proprietes.indexParcDeInfra,
                    let sport = obtenirSport(chaine: objet.proprietes.nomInfra!),
                    !sport.isEmpty // Retirer tous les infrastructres dont la liste de Sport est vide (en d'autres mots, c'est le nomInfra ne contient pas un sport parmi `enum` Sport)
                else { return nil }
                
                guard let point = objet.geometrie.point,
                      point.count >= 2 else { return nil }
                let coordonnees = CLLocationCoordinate2D(
                    latitude: point[1],
                    longitude: point[0]
                )
         
                return Infrastructure(id: id, indexParc: indexParc, coordonnees: coordonnees, sport: sport)
            }
            
            // Regroupement des features de parc par index
            let parcsGroupes = Dictionary(grouping: objetsParc) { $0.proprietes.indexParcDeParc! }
            
            // Construction des objets Parc
            let parcs: [Parc] = parcsGroupes.compactMap { (index, features) in
                // On prend le nom et autres infos à partir de la première feature
                let first = features.first!
                let nom = [
                    first.proprietes.typeParc,
                    first.proprietes.lien,
                    first.proprietes.nomParc
                ]
                .compactMap { $0 }
                .joined(separator: " ")
                
                // Agrégation des coordonnées de chacun des polygones
                let limites = features.compactMap { feature -> [CLLocationCoordinate2D]? in
                    if let poly = feature.geometrie.polygone, let firstRing = poly.first {
                        return firstRing.compactMap { point in
                            guard point.count >= 2 else { return nil }
                            return CLLocationCoordinate2D(latitude: point[1], longitude: point[0])
                        }
                    }
                    return nil
                }.flatMap { $0 }
                
                let idsInfra = infrastructures // On veut l'ID des infrastructures qui font parti du parc traite
                    .filter { $0.indexParc == index }
                    .compactMap { $0.id }
                guard !idsInfra.isEmpty else { return nil }

                return Parc(index: index, nom: nom, limites: limites, idsInfra: idsInfra)
            }
            
            return (infrastructures, parcs)
        } catch {
            print("Erreur : \(error.localizedDescription)", error)
            return ([], [])
        }
    }
    
    private func obtenirSport(chaine: String) -> [Sport]? {
        return Sport.allCases.filter { sport in
            chaine.localizedCaseInsensitiveContains(sport.rawValue)
        }
    }
    
    
}

extension EmplacementsVueModele {
    func sports(for parc: Parc) -> Set<Sport> {
        return Set(
            infrastructures
                .filter { $0.indexParc == parc.index }
                .flatMap { $0.sport }
        )
    }
}
