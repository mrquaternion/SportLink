//
//  ExplorerListeVM.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-10.
//

import Foundation
import CoreLocation
import SwiftUI
import Combine


enum OptionTri { case date, dateInv, distance, distanceInv }

@MainActor
class ExplorerListeVM: ObservableObject {
    private let serviceActivites: ServiceActivites
    private let serviceEmplacements: DonneesEmplacementService
    private let gestionnaireLocalisation = GestionnaireLocalisation.instance
    
    @Published var estEnChargement = false
    @Published var optionTri: OptionTri = .date
    @Published var texteDeRecherche: String = ""
    @Published var dateAFiltree: Date = .now
    @Published var sportsChoisis: Set<String> = []
    
    @Published private(set) var activites: [Activite] = []
    @Published private(set) var activitesTriees: [Activite] = []
    
    let dateMin: Date
    let dateMax: Date
    
    init(serviceEmplacements: DonneesEmplacementService, serviceActivites: ServiceActivites) {
        self.serviceEmplacements = serviceEmplacements
        self.serviceActivites = serviceActivites
        
        // Même chose que dans CreerActiviteVM
        let (min, max, start) = Self.configurerDatesInitiales()
        self.dateMin = min
        self.dateMax = max
        self.dateAFiltree = start
        
        ajouterSubscribers()
    }
    
    func chargerActivites() async {
        estEnChargement = true
        await serviceActivites.fetchTousActivites()
        self.activites = serviceActivites.activites
        estEnChargement = false
    }
    
    func ajouterSubscribers() {
        $optionTri
            .combineLatest($texteDeRecherche, $dateAFiltree, $sportsChoisis)
            .combineLatest($activites)
            .map { arguments, activites in
                let (option, texte, date, sports) = arguments
                return self.chercherFiltrerEtTrier(
                    option: option,
                    texte: texte,
                    date: date,
                    sports: sports,
                    activites: activites
                )
            }
            .assign(to: &$activitesTriees)
    }
    
    private func chercherFiltrerEtTrier(
        option: OptionTri,
        texte: String,
        date: Date,
        sports: Set<String>,
        activites: [Activite]
    ) -> [Activite] {
        let activitesCherchees = chercher(pour: texte, activites: activites)
        let activitesFiltrees = filtrer(par: sports, pour: date, activites: activitesCherchees)
        return trier(par: option, activites: activitesFiltrees)
    }
    
    private func chercher(pour texte: String, activites: [Activite]) -> [Activite] {
        guard !texte.isEmpty else { return activites }

        let texteNormalise = texte.folding(options: .diacriticInsensitive, locale: .current).lowercased()

        return activites.filter { activite in
            guard let parc = obtenirObjetParcAPartirInfra(pour: activite.infraId),
                  let nom = parc.nom else { return false }
            
            let nomNormalise = nom.folding(options: .diacriticInsensitive, locale: .current) .lowercased()
            
            let titre = activite.titre
            let titreNormalise = titre.folding(options: .diacriticInsensitive, locale: .current) .lowercased()

            return nomNormalise.contains(texteNormalise) || titreNormalise.contains(texteNormalise)
        }
    }
    
    private func filtrer(par sports: Set<String>, pour date: Date, activites: [Activite]) -> [Activite] {
        var resultat = activites

        // Filtrage par sport
        if !sports.isEmpty {
            resultat = resultat.filter { sports.contains($0.sport.lowercased()) }
        }

        // Filtrage par date (même jour)
        let calendrier = Calendar.current
        resultat = resultat.filter {
            calendrier.isDate($0.date.debut, inSameDayAs: date)
        }

        return resultat
    }
    
    private func trier(par option: OptionTri, activites: [Activite]) -> [Activite] {
        switch option {
        case .date: return activites.sorted { $0.date.debut < $1.date.debut }
        case .dateInv: return activites.sorted { $0.date.debut > $1.date.debut }
        case .distance: return activites.sorted { calculerDistance(activite: $0) < calculerDistance(activite: $1) }
        case .distanceInv: return activites.sorted { calculerDistance(activite: $0) > calculerDistance(activite: $1) }
        }
    }
    
    private func calculerDistance(activite: Activite) -> Double {
        guard
            let userLoc = gestionnaireLocalisation.location?.coordinate,
            let infraCoords = obtenirObjetInfrastructure(pour: activite.infraId)?.coordonnees
        else { return 0.0 }
        
        let dist = calculerDistanceEntreCoordonnees(
            position1: userLoc,
            position2: infraCoords
        )
        return dist
    }
    
    private static func configurerDatesInitiales() -> (min: Date, max: Date, start: Date) {
        let maintenant = Date.now
        let calendrier = Calendar.current
        let heureActuelle = calendrier.component(.hour, from: maintenant)
        let valeurDeBase: Date

        if heureActuelle >= 22 || heureActuelle < 6 {
            let debutAujourdhui = calendrier.startOfDay(for: maintenant)
            let debutDemain = calendrier.date(byAdding: .day, value: 1, to: debutAujourdhui)!
            valeurDeBase = calendrier.date(bySettingHour: 6, minute: 0, second: 0, of: debutDemain)!
        } else {
            valeurDeBase = maintenant
        }
        
        let dateMin = valeurDeBase
        let dateMax = calendrier.date(byAdding: .weekOfYear, value: 4, to: valeurDeBase)!
        return (dateMin, dateMax, valeurDeBase)
    }
    
    func obtenirObjetInfrastructure(pour infraId: String) -> Infrastructure? {
        guard let infra = serviceEmplacements.infrastructures.first(where: { $0.id == infraId })
        else { return nil }
        return infra
    }
    
    func obtenirObjetParcAPartirInfra(pour infraId: String) -> Parc? {
        guard let infra = obtenirObjetInfrastructure(pour: infraId) else { return nil }
        return serviceEmplacements.parcs.first { $0.index == infra.indexParc }
    }
    
    func obtenirDistanceDeUtilisateur(pour activite: Activite) -> String {
        guard
            let userLoc = gestionnaireLocalisation.location?.coordinate,
            let infraCoords = obtenirObjetInfrastructure(pour: activite.infraId)?.coordonnees
        else {
            return ""
        }
        
        let dist = calculerDistanceEntreCoordonnees(
            position1: userLoc,
            position2: infraCoords
        )
        
        if dist < 1 {
            let distConvertie = dist * 1000
            return String(format: "%d m", Int(distConvertie))
        } else {
            return String(format: "%.1f km", dist)
        }
    }
}
