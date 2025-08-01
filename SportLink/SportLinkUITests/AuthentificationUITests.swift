//
//  AuthenticationUITests.swift
//  SportLinkUITests
//
//  Created by Mathias La Rochelle on 2025-07-31.
//

import XCTest

final class AuthentificationUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UI_TESTING", "RESET_AUTH_STATE"]
        app.launchEnvironment = ["UI_TESTING": "1"]
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    @MainActor
    func testSignInAvecInfosValides() throws {
        app.launch()
        deconnecterAvantDeSeConnecter()
        remplirEtSoumettreFormulaire(email: "testing@example.com", motDePasse: "test123")
        
        // MARK: Page Home
        let tabBarApparait = app.buttons["Home"].waitForExistence(timeout: 10)
        let chargementApparait = app.activityIndicators.firstMatch.waitForExistence(timeout: 3)
        
        XCTAssertTrue(tabBarApparait || chargementApparait, "Devrait montrer la page Home de l'app, ou du moins une vue authentifié.")
    }
    
    @MainActor
    func testSignInAvecInfosInvalides() throws {
        app.launch()
        deconnecterAvantDeSeConnecter()
        remplirEtSoumettreFormulaire(email: "invalid@gmail.com", motDePasse: "wrongpassword")
        
        // MARK: Message(s) d'erreur
        let messageErreur = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Incorrect'")).firstMatch
        XCTAssertTrue(messageErreur.waitForExistence(timeout: 5), "Le message d'erreur devrait apparaitre.")
    }
    
    func deconnecterAvantDeSeConnecter() {
        let boutonProfil = app.buttons["Profil"]
        if boutonProfil.waitForExistence(timeout: 10) {
            boutonProfil.tap()
            
            let boutonSignOut = app.buttons["Sign Out"]
            XCTAssertTrue(boutonSignOut.exists, "Le bouton Sign Out n'existe pas.")
            boutonSignOut.tap()
        }
    }
    
    @discardableResult
    func remplirEtSoumettreFormulaire(email: String, motDePasse: String) -> Bool {
        let texteDeBienvenue = app.staticTexts["Welcome to SportLink!"]
        XCTAssertTrue(texteDeBienvenue.waitForExistence(timeout: 5))

        let champCourriel = app.textFields.matching(identifier: "champDeTexte").firstMatch
        XCTAssertTrue(champCourriel.exists, "Le champ de texte pour le courriel n'existe pas.")
        champCourriel.tap()
        champCourriel.typeText(email)

        let champMDP = app.secureTextFields.matching(identifier: "champAvecOeilActive").firstMatch
        XCTAssertTrue(champMDP.exists, "Le champ de texte pour le mot de passe n'existe pas.")
        champMDP.tap()
        champMDP.typeText(motDePasse)

        app.keyboards.buttons["Return"].tap()

        let boutonSignIn = app.buttons["Sign In"]
        XCTAssertTrue(boutonSignIn.exists, "Le bouton Sign In n'existe pas.")
        boutonSignIn.tap()

        return true
    }
    
    @MainActor
    func testFluxEnregistrement() throws {
        app.launch()
        deconnecterAvantDeSeConnecter()
        
        let texteDeBienvenue = app.staticTexts["Welcome to SportLink!"]
        XCTAssertTrue(texteDeBienvenue.waitForExistence(timeout: 5))
        
        let boutonRegister = app.buttons["Register"]
        XCTAssertTrue(boutonRegister.exists, "Le bouton Register n'existe pas.")
        boutonRegister.tap()
        
        let texteCreerCompte = app.staticTexts["Create Your Account"]
        XCTAssertTrue(texteCreerCompte.waitForExistence(timeout: 3))
        
        let champsDeTexte = app.textFields.matching(identifier: "champDeTexte")
        if champsDeTexte.count == 2 {
            champsDeTexte.element(boundBy: 0).tap()
            champsDeTexte.element(boundBy: 0).typeText("Test User")

            let timestamp = Int(Date().timeIntervalSince1970)
            let courrielUnique = "test+\(timestamp)@example.com"
            champsDeTexte.element(boundBy: 1).tap()
            champsDeTexte.element(boundBy: 1).typeText(courrielUnique)
        }
        
        let boutonsVisibiliteMDP = app.buttons.matching(identifier: "basculerVisibiliteMDP")
        for i in 0..<boutonsVisibiliteMDP.count {
            let bouton = boutonsVisibiliteMDP.element(boundBy: i)
            XCTAssertTrue(bouton.exists, "Le bouton \(i) pour basculer à visible n'existe pas.")
            bouton.tap()
        }
        
        app.keyboards.buttons["Return"].tap()
        
        let champsMDP = app.textFields.matching(identifier: "champAvecOeilDesactive")
        if champsMDP.count == 2 {
            champsMDP.element(boundBy: 0).tap()
            champsMDP.element(boundBy: 0).typeText("password123")
            
            champsMDP.element(boundBy: 1).tap()
            champsMDP.element(boundBy: 1).typeText("password123")
        }
        
        app.keyboards.buttons["Return"].tap()
        
        let boutonContinuer = app.buttons["Continue"]
        XCTAssertTrue(boutonContinuer.exists, "Le bouton Continue n'existe pas.")
        boutonContinuer.tap()
            
        // MARK: Selection des sports favoris
        let pageSelectionSport = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Sports'")).firstMatch.waitForExistence(timeout: 5)
        XCTAssertTrue(pageSelectionSport, "Devrait procéder à la sélection des sports.")
    }
}
