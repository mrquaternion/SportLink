//
//  SwiftUIView.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-15.
//

import SwiftUI
import MapKit

class DonneesEmplacementService: ObservableObject {
    @Published var infrastructures: [Infrastructure] = []
    @Published var parcs: [Parc] = []
    
    func chargerDonnees() {
        do {
            // Parsing des deux fichiers JSON
            let collectionInfra = try ChargeurJSON.chargementCollection(from: "terrain_sport_ext")
            let collectionParc = try ChargeurJSON.chargementCollection(from: "espace_vert")
            
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
            
            // Construction des objets Parc
            let parcs: [Parc] = objetsParc.compactMap { parc -> Parc? in
                let index = parc.proprietes.indexParcDeParc!
                let nom = [
                    parc.proprietes.typeParc,
                    parc.proprietes.lien,
                    parc.proprietes.nomParc
                ]
                .compactMap { $0 }
                .joined(separator: " ")
                
                let limites: [CLLocationCoordinate2D] = {
                    if let firstRing = parc.geometrie.polygone?.first as? [[Double]] {
                        return firstRing.compactMap { point in
                            guard point.count >= 2 else { return nil }
                            return CLLocationCoordinate2D(latitude: point[1], longitude: point[0])
                        }
                    }
                    return []
                }()
                
                let idsInfra = infrastructures // On veut l'ID des infrastructures qui font parti du parc traite
                    .filter { $0.indexParc == parc.proprietes.indexParcDeParc }
                    .filter { entreLimites(for: $0.coordonnees, in: limites) }
                    .compactMap { $0.id }
                guard !idsInfra.isEmpty else { return nil }

                return Parc(index: index, nom: nom, limites: limites, idsInfra: idsInfra)
            }
            
            self.infrastructures = infrastructures
            self.parcs = parcs
        } catch {
            print("Erreur : \(error.localizedDescription)", error)
        }
    }
    
    private func obtenirSport(chaine: String) -> [Sport]? {
        return Sport.allCases.filter { sport in
            chaine.localizedCaseInsensitiveContains(sport.rawValue)
        }
    }
}

extension DonneesEmplacementService {
    func sports(for parc: Parc) -> Set<Sport> {
        return Set(
            infrastructures
                .filter { $0.indexParc == parc.index }
                .flatMap { $0.sport }
        )
    }
}
