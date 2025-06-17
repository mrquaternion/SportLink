//
//  DecoderJSON.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-14.
//

import Foundation

struct Collection: Codable {
    let objets: [Objet]
    
    enum CodingKeys: String, CodingKey {
        case objets = "features"
    }
}

struct Objet: Codable {
    let geometrie: Geometrie
    let proprietes: Proprietes
    
    enum CodingKeys: String, CodingKey {
        case geometrie = "geometry"
        case proprietes = "properties"
    }
}

struct Geometrie: Codable {
    let type: String
    let point : [Double]?
    let polygone: [[[Double]]]?
    
    enum CodingKeys: String, CodingKey {
        case type
        case coordonnees = "coordinates"
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        type = try c.decode(String.self, forKey: .type)
        switch type {
        case "Point":
            point = try c.decode([Double].self, forKey: .coordonnees)
            polygone = nil
        case "Polygon":
            polygone = try c.decode([[[Double]]].self, forKey: .coordonnees)
            point = nil
        case "MultiPolygon":
            point = nil
            polygone = nil
        default:
            throw DecodingError.dataCorruptedError(
                forKey: .type,
                in: c,
                debugDescription: "Type de géométrie inattendu : \(type)"
            )
        }
    }
}

struct Proprietes: Codable {
    let indexParcDeParc: String?
    let indexParcDeInfra: String?
    let idInfra: String?
    let nomParc: String?
    let nomInfra: String?
    let typeParc: String?
    let typeInfra: String?
    let lien: String?
    let gestion: String?
    
    enum CodingKeys: String, CodingKey {
        case indexParcDeParc = "NUM_INDEX"
        case indexParcDeInfra = "INDEX_PARC"
        case idInfra = "ID"
        case typeParc = "Type"
        case typeInfra = "TYPE"
        case lien = "Lien"
        case nomParc = "Nom"
        case nomInfra = "NOM"
        case gestion = "GESTION"
    }
}


extension Geometrie {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        switch type {
        case "Point":
            try encoderCoordonnees(point, forKey: .coordonnees, in: &container)
        case "Polygon":
            try encoderCoordonnees(polygone, forKey: .coordonnees, in: &container)
        default:
            break
        }
    }
    
    func encoderCoordonnees<T: Codable>(_ value: T?, forKey key: CodingKeys, in container: inout KeyedEncodingContainer<CodingKeys>) throws {
        guard let geometrie = value else {
            throw EncodingError.invalidValue(
                type,
                .init(
                    codingPath: [CodingKeys.coordonnees],
                    debugDescription: "Coordonnées manquantes pour le type \(type)"
                )
            )
        }
        try container.encode(geometrie, forKey: .coordonnees)
    }
}
