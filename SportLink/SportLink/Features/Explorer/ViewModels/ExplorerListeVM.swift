//
//  ExplorerListeVM.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-10.
//

import Foundation
import CoreLocation
import SwiftUI

class ExplorerListeVM {
    func obtenirInfrastructureObj(pour infraId: String, service: DonneesEmplacementService) -> Infrastructure? {
        guard let infra = service.infrastructures.first(where: { $0.id == infraId })
        else { return nil }
        return infra
    }
    
    func obtenirParcObjAPartirInfra(pour infraId: String, service: DonneesEmplacementService) -> Parc? {
        let infra = obtenirInfrastructureObj(pour: infraId, service: service)
        
        guard let parc = service.parcs.first(where: { $0.index == infra!.indexParc })
        else { return nil }
        return parc
    }
}
