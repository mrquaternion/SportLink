//
//  Message.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-14.
//

import Foundation

struct Message: Identifiable {
    var id = UUID().uuidString
    
    let auteurId: UtilisateurID
    let contenu: String
    let timestamp: Date
}

struct MessageID: Hashable, Codable {
    let valeur: String
}

extension String {
    var enMessageID: MessageID {
        MessageID(valeur: self)
    }
}
