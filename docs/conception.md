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
Voici le modèle de données style NoSQL qui réflète les *entités métiers*. C'est ainsi que les données seront stockées dans Firebase.
### `utilisateurs`
```txt
utilisateurs    (collection)
└── {utilisateurId}
    ├── nomUtilisateur        : "mimi123"
    ├── courriel              : "michel@example.com"
    ├── photoProfil           : "https://..."
    ├── disponibilites        : ["lundi_AM", "lundi_PM", "mardi_AM"] 
    ├── sportsFavoris         : ["Soccer", "Tennis"]                         
    ├── favorisActivites      : ["eventId4","eventId9"]              
    └── partenairesRecents    : [                                    
    │     { utilisateurId: "autreId",
    │       sport: "Soccer",
    │       dernierResultat: +10 }
    │   ]
```

### `activites`
```txt
activites    (collection)
├── {activiteId}
    ├── organisateurId : "utilisateurId"
    ├── sport : "Basketball"
    ├── date : "2025-06-12T17:00"
    ├── duree : "02:00"
    ├── nbJoueursRecherches : 6
    ├── participants : [utilisateurId1, utilisateurId2]
    ├── statut : "ouvert" | "complet" | "annule"
    ├── emplacement : emplacementId
    ├── invitationsOuvertes : true 
    └── messages : [messageId1, messagesId2, ...]
```

### `messages`
```txt
messages    (collection)
└── {messageId}
    ├── auteurId : "utilisateurId1",
    ├── contenu : "Salut !",
    └── timestamp : "2025-05-31T12:10:00"
```

### `emplacements`
```txt
emplacements    (collection)
└── {emplacementId}
    ├── nomEmplacement    : "Parc Jean-Drapeau"
    ├── latitude          : 45.508
    ├── longitude         : -73.554
    ├── sportsDisponibles : ["Basketball", "Soccer"]
    └── heuresOuvertures  : "08:00-22:00"
```


## Prototype
La maquette Figma se trouve [ici](https://www.figma.com/design/N0QDEh5Shuht6eS3dpvKTB/SportLink?node-id=0-1&t=CBkQlTjm84oNgfAk-1).