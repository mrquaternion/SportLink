# Conception

## Architecture

- Décrire l'architecture du système proposé.

## Choix technologiques

- Justifier les technologies et outils choisis.

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
```

### `discussions`

```txt
discussions
├── discussionId
    ├── activiteId : "activiteId"
    ├── participants : [utilisateurId1, utilisateurId2]
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