//
//  ActivitesVMTests.swift
//  SportLinkTests
//
//  Created by AI Assistant on 2025-07-31.
//

import Testing
import Foundation
import MapKit
@testable import SportLink

@MainActor
struct ActivitesVMTests {
    private func creerMockEmplacementService() -> DonneesEmplacementService {
        let service = DonneesEmplacementService()
        service.chargerDonnees()
        return service
    }
    
    private func creerMockActivite(infraId: String = "test-infra-123") -> Activite {
        return Activite(
            titre: "Test Soccer Match",
            organisateurId: UtilisateurID(valeur: "organizer123"),
            infraId: infraId,
            sport: .soccer,
            date: DateInterval(start: Date(), duration: 3600),
            nbJoueursRecherches: 10,
            participants: [],
            description: "Test activity description",
            statut: .ouvert,
            invitationsOuvertes: true,
            messages: []
        )
    }
    
    @Test("ActivitesVM initialisé correctement")
    func activitesVMInitialisation() {
        let mockService = creerMockEmplacementService()
        let vm = ActivitesVM(serviceEmplacements: mockService)
        
        #expect(vm.imageApercu == nil)
    }
    
    @Test("Calcul de la distance quand aucun utilisateur est authentifié")
    func distanceCalculNoGeolocalisationUtilisateur() {
        let mockService = creerMockEmplacementService()
        let vm = ActivitesVM(serviceEmplacements: mockService)
        let activite = creerMockActivite()
        
        let distance = vm.obtenirDistanceDeUtilisateur(pour: activite)
        #expect(distance.isEmpty)
    }
    
    @Test("Calcul de la distance quand une infrastructure est trouvée")
    func distanceCalculNoInfrastructure() {
        let mockService = creerMockEmplacementService()
        let vm = ActivitesVM(serviceEmplacements: mockService)
        let activite = creerMockActivite(infraId: "018-0029")
  
        let distance = vm.obtenirDistanceDeUtilisateur(pour: activite)
        #expect(!distance.isEmpty)
    }
    
    @Test("Obtention infrastructure et parc n'est pas nul")
    func obtentionObjetInfrastructureParcAPartirInfrastructureID() {
        let mockService = creerMockEmplacementService()
        let vm = ActivitesVM(serviceEmplacements: mockService)
        let infraId = "018-0029" // vraie donnee
        
        let (infra, parc) = vm.obtenirInfraEtParc(infraId: infraId)
        
        #expect(infra != nil)
        #expect(parc != nil)
    }
}
