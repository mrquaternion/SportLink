# Conception

## Architecture
```plaintext
SportLink/
├── App/
|   ├── SportLinkApp.swift
|   └── EtatApp.swift
|
├── Fonctionnalitees/
|   ├── Accueil/
|   |   ├── Vues/
|   |   ├── VuesModeles/
|   |   └── Sousvues/
│   ├── Explorer/
|   |   ├── Vues/
|   |   ├── VuesModeles/
|   |   └── Sousvues/
│   ├── Creer/
|   |   ├── Vues/
|   |   ├── VuesModeles/
|   |   └── Sousvues/
│   ├── Activites/
|   |   ├── Vues/
|   |   ├── VuesModeles/
|   |   └── Sousvues/
│   └── Profil/
|       ├── Vues/
|       ├── VuesModeles/
|       └── Sousvues/
|
├── ModelesPartagees/
|   ├── Utilisateur.swift
|   ├── Activite.swift
|   ├── Message.swift
|   └── Emplacement.swift
|
├── ComposantesUI/
|   ├── Boutons/
|   ├── Icones/
|   └── Cartes/
|
├── Services/
|   ├── Geolocalisation/
│   |   └── ServiceEmplacement.swift
|   ├── Authentification/
│   |   └── ServiceUtilisateur.swift
|   └── Reseau/
│       └── APIClient.swift
|
└── Ressources/
    └── Actifs/
```

## Choix technologiques
Nous avons opté pour un développement **natif iOS en Swift**, pour :

- Utilisation de `Xcode` comme IDE pour le code et la simulation en temps réelle

    - Tirer parti des composants natifs (localisation, notifications)

    - Cibler uniquement iOS 17+ pour simplifier les tests https://developer.apple.com/support/app-store/ [_Statistiques de répartition des versions iOS_]

- Utilisation du framework `SwiftUI` afin de bénéficier de la stabilité et des performances natives

- Utilisation de `Firebase` pour le backend, plus exactement `Cloud Firestore`

## Modèles et diagrammes
Nous avons décidé de ne pas mettre les sous vues dans le diagramme, car nous pensons qu'il deviendrait trop grossier avec toutes les classes qui n'ont pas nécessairement d'attributs ou de méthodes pertinentes.
![Diagramme de classe UML](./diagrams/out/SportLink.svg "Diagramme de classe UML")

## Modèle de données


### `utilisateurs`
```txt
utilisateurs
├── utilisateurId
    ├── nomUtilisateur : "mimi123"
    ├── courriel : "michel@example.com"
    ├── motDePasseHash : "hashed_pw"
    ├── photoProfil : "https://..."
    ├── disponibilites :
    │   ├── lundi : ["AM", "PM"]
    │   ├── mardi : ["AM"]
    │   └── ...
    ├── sportsFavoris : ["Soccer", "Tennis"]
    ├── mode : "recreatif" | "competitif"
    ├── pointsParSport :
    │   ├── Soccer : 1200
    │   ├── Tennis : 800
    ├── niveauParSport :
    │   ├── Soccer : 3
    │   ├── Tennis : 2
    ├── activitesOrganises : [eventId1, eventId2]
    ├── activitesInscrits : [eventId3]
    ├── activitesFavoris : [eventId4]
    ├── partenairesRecents : [
    │     {
    │       utilisateurId : "autreId",
    │       sport : "Soccer",
    │       activitesPartagees : 4,
    │       dernierResultat : "+10"
    │     }
    │   ]
```

### `activites`

```txt
activites
├── activiteId
    ├── organisateurId : "utilisateurId"
    ├── sport : "Basketball"
    ├── date : "2025-06-12"
    ├── heureDebut : "18:00"
    ├── heureFin : "20:00"
    ├── lieu :
    │   ├── nom : "Parc Jean-Drapeau"
    │   ├── latitude : 45.508
    │   ├── longitude : -73.554
    ├── niveau : 2
    ├── maxParticipants : 6
    ├── participants : [utilisateurId1, utilisateurId2]
    ├── statut : "ouvert" | "complet" | "annule"
    ├── discussionId : "chat123"
    ├── messages : [
    │     {
    │       auteurId : "utilisateurId1",
    │       contenu : "Salut !",
    │       timestamp : "2025-05-31T12:10:00"
    │     }
    │   ]
```


## Prototype
La maquette Figma se trouve [ici](https://www.figma.com/design/N0QDEh5Shuht6eS3dpvKTB/SportLink?node-id=0-1&t=CBkQlTjm84oNgfAk-1).