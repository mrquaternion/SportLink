//
//  Parc.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-15.
//

import Foundation

struct Parc: Decodable {
    let index: String
    let nom: String?
    let limites: Geometrie
    let idsInfra : [String]
    let heuresOuvertures : [String]?
    
    enum Geometrie: Decodable {
        case polygon([[[Double]]])
        case multiPolygon([[[[Double]]]])

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let polygon = try? container.decode([[[Double]]].self) {
                self = .polygon(polygon)
            } else if let multi = try? container.decode([[[[Double]]]].self) {
                self = .multiPolygon(multi)
            } else {
                throw DecodingError.typeMismatch(
                    Geometrie.self,
                    .init(
                        codingPath: decoder.codingPath,
                        debugDescription: "Format géométrie inattendu"
                    )
                )
            }
        }
    }
}
