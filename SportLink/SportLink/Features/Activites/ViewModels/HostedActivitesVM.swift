//
//  HostedActivitesVM.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-10.
//


import Foundation

@MainActor
class HostedActivitesVM: ObservableObject {
    @Published var hostedActivites: [Activite] = []

    private let service = ServiceActivites()

    func chargerHostedActivitesPour(organisateurId: String) async {
        let activites = await service.fetchActivitesParOrganisateur(organisateurId: organisateurId)
        self.hostedActivites = activites
    }
}
