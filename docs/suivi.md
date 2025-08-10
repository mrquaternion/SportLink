# Suivi de projet

## Semaine 1

??? note "Étapes faites"
    - [x] Création du répertoire sur GitHub
    - [x] Compléter les sections du site web pour la semaine 1
        * [x] Formuler concrètement la description du projet ; le contexte, la problématique et les objectifs
        * [x] Développer les prochaines étapes
        * [x] Élaborer les difficultés rencontrées
    - [x] Décider le langage de programmation du développement de l'application

!!! info "Notes"
    - Il est possible que nous révisions les exigences après le prototypage

!!! warning "Difficultés rencontrées"
    - Doute sur l'étendue du projet au niveau du langage de programmation et des frameworks — entre Swift (développement natif) et Flutter/Dart (développement multiplateforme).
        - *En cours de discussion...*

!!! abstract "Prochaines étapes"
    - Démarrer la réalisation du diagramme de classes UML
    - Réviser l'interface du prototype mi-design et de sa logique
    - Créer la structure de `etudes_preliminaires.md`

---

## Semaine 2

??? note "Étapes faites"
    - [x] Élaborer nos exigences fonctionnelles et non-fonctionnelles
    - [x] Faire l'étude préliminaire par rapport aux choix de la plateforme
    - [x] Démarrer la réalisation du diagramme de classes UML (draw.io) | *Update* : on utilise PlantUML maintenant
    - [x] Réviser l'interface du prototype mi-design et de sa logique (Figma)

!!! info "Notes"
    - Nous avons préciser notre décision sur le choix de la plateforme (Swift) par rapport à l'éllaboration et la clarifications de nos exigences. On mise sur notre habileté avec Swift afin de livrer une application plus riche en intégrant des fonctionnalités natives à cette OS.

!!! warning "Difficultés rencontrées"
    - Nous devons décidés si on part avec l'option 1 ou l'option 2 de la carte dans le menu Explore (voir Études préliminaires).

!!! abstract "Prochaines étapes"
    - Finaliser le diagramme de classes UML
    - Commencer à regarder des ressources en ligne (articles, vidéos) à propos de la programmation en Swift
    - Créer la hiérarchie des fichiers du projet à partir de l'arborescence dans le `README`
    - Préparer le document pour la remise *Description de projet* sur StudiuM
  
---

## Semaine 3

??? note "Étapes faites"
    - [x] Avancement du prototype dans Figma : ajustements esthétiques et amélioration de l’ergonomie
    - [x] Début de la modélisation des classes UML dans PlantUML
    - [x] Analyse des besoins en structure de données avant de poursuivre le diagramme UML

!!! info "Notes"
    - En travaillant sur le diagramme UML, nous avons réalisé qu’il nous manquait un modèle de données clair pour représenter les relations et les structures attendues dans notre application. Cela nous a amenés à mettre temporairement le diagramme UML en pause pour mieux cadrer les entités clés et leurs attributs.

!!! warning "Difficultés rencontrées"
    - Beaucoup de questionnements autour de la confection du diagramme UML. Nous avon conclus qu'une une base de données solide pourrait aider à la conception du diagramme UML. Certaines relations entre les classes étaient ambiguës.

!!! abstract "Prochaines étapes"
    - Élaborer un modèle de données complet
    - Reprendre et compléter le diagramme UML à partir du modèle de données défini


---

## Semaine 4

??? note "Étapes faites"
    - [x] Poursuite du raffinement du prototype Figma
    - [x] Finalisation et présentation au superviseur du modèle de données
    - [x] Création et configuration initiale de la base de données Firebase

!!! info "Notes"
    - Le modèle de données a été validé dans l’ensemble par notre superviseur, mais certaines corrections mineures devront être apportées 
    - L’ouverture de notre base de données Firebase nous permettra de commencer à tester l’intégration réelle avec l’application à venir.

!!! warning "Difficultés rencontrées"
    - Certaines incohérences entre le modèle de données et le diagramme UML ont été relevées — une mise à jour sera nécessaire pour assurer la cohérence.

!!! abstract "Prochaines étapes"
    - Apporter les corrections demandées au modèle de données
    - Réviser le diagramme UML pour qu’il reflète fidèlement la structure de données finale
    - Continuer le développement du prototype Figma selon les retours obtenus

---

## Semaine 5

??? note "Étapes faites"
    - [x] Finalisation du prototype Figma
    - [x] Préparation du prototype en vue de sa présentation à la foire (Semaine 6)

!!! info "Notes"
    - Le prototype Figma est désormais terminé et prêt à être présenté lors de la foire avec les autres équipes.
    - L’accent a été mis cette semaine sur le raffinement visuel, l’expérience utilisateur et la fluidité de navigation.

!!! warning "Difficultés rencontrées"
    - Aucun problème majeur cette semaine, mais le temps investi dans le perfectionnement du prototype a laissé peu de marge pour d'autres tâches comme l’implémentation Firebase ou la mise à jour du diagramme UML.

!!! abstract "Prochaines étapes"
    - Présenter le prototype à la foire et recueillir les retours des pairs et des encadrants
    - Reprendre l’intégration de Firebase et corriger les points soulevés dans le modèle de données
    - Mettre à jour le diagramme UML pour qu’il corresponde aux derniers ajustements conceptuels

---


## Semaine 6 (8-14 juin)

??? note "Étapes faites"
    - [x] Participation à la foire et collecte des commentaires et critiques
    - [x] Ajustement du modèle de données
    - [x] Finalisation du diagramme UML

!!! info "Notes"
    - Plusieurs interrogations ont été soulevées par les pairs, et plusieurs critiques ont été retenues pour orienter la suite du projet :
        * La complexité entourant le mode compétitif nous a amenés à conclure qu’il est préférable de ne pas le développer davantage. Seul le mode récréatif sera conservé.

!!! warning "Difficultés rencontrées"
    - Nombreux questionnements autour des pointeurs sur la carte, notamment en ce qui concerne leur fonctionnement, leur précision et leur nombre en fonction du niveau de zoom.
    - Réflexion sur l’abandon du mode compétitif : devons-nous conserver un certain système de pointage même en mode récréatif ?

!!! abstract "Prochaines étapes"
    - Début de la conception de l’application dans Xcode.
    - Tests d’intégration avec la base de données Firebase
    - Faire un logo

---

## Semaine 7 (15-21 juin)

??? note "Étapes faites"
    - [x] Implémentation de la base de l’application sur Xcode
    - [x] Conception de la vue pour les pages d’inscription et de connexion
    - [x] Début de la conception de la vue pour les informations d’un événement particulier

!!! info "Notes"
    - Une décision a été prise concernant l’affichage des pointeurs sur la carte : à un certain niveau de zoom peu élevé, si plusieurs parcs sont trop rapprochés, un pointeur chiffré s’affichera indiquant le nombre de parcs dans ce secteur. En appuyant sur ce pointeur ou en zoomant davantage, plusieurs pointeurs individuels apparaîtront.
    - De même, lorsqu’un parc spécifique est sélectionné ou que l’utilisateur effectue un zoom sur celui-ci, des pointeurs supplémentaires s’afficheront autour du périmètre du parc, indiquant les différents sports pouvant y être pratiqués.

!!! warning "Difficultés rencontrées"
    - Aucune difficulté majeure rencontrée. Nos réflexions actuelles nous permettent de mieux visualiser le produit final, tout en gardant en tête les contraintes et réalités techniques du projet.
    - Aucune décision n’a encore été prise quant à l’intégration ou non d’un système de pointage dans le mode récréatif.

!!! abstract "Prochaines étapes"
    - Conception de la vue de la page *Explorer*.
    - Conception de la vue de la page *Création d’événement*.

---

## Semaine 8 (22-28 juin)

??? note "Étapes faites"
    - [x] Conception de la vue de la page *Explorer*.
    - [x] Conception de la vue de la page *Création d’événement*.
    - [x] Début de l'implémentation des pointeurs (parc et sport)
    


!!! info "Notes"
    - À discuter : Dans la carte de création d'évènement, il sera probalemment préférable d'ajouter une barre de recherche pour pour faire une recherche par le nom d'un parc ou une adresse. Cela pourra probalblement faciliter la recherche tout en gardant la fonctionnalité de la carte implémenté dans le mode *Explorer*

!!! warning "Difficultés rencontrées"
    - Les marqueurs personnalisés sont très difficile à implémenter pour plusieurs raisons :
        * Plus lours à gérer visuellement (scaling, animation)
        * Demande beaucoup de ressources
        * Difficlie à mettre à jour en temps réel
    - API de la ville de Montréal ne marche pas, nous devons dont avoir recours aux fichier rae JSON


!!! abstract "Prochaines étapes"
    - Débuter certain fonctionnalité de la création d'évènement, comme pourvoir les stocker dans le Firebase. Faire fonctionné la carte
    - Faire la version liste de la page Explore
    - Faire le mode vue de la page *Home*
    - Faire le mode vue de la page *Profil*

---

## Semaine 9 (29 juin – 5 juillet)

??? note "Étapes faites"
    - [x] Finalisation du mode *Carte* de la vue *Explorer*.
    - [x] Finalisation de la vue *Créer évènement*.
    - [x] Test d'une première implémentation de la création d'évènement avec la base de données *Firebase*.

!!! info "Notes"
    - Nous avons réussi à implémenter une carte intelligente qui filtre dynamiquement les infrastructures lors de la création d’un évènement. Lorsqu’un sport est sélectionné, seuls les pointeurs correspondant aux parcs offrant les infrastructures pour ce sport sont affichés sur la carte.
    - La page *Home* sera réalisée en dernier.
    - La page *Profil* n’est pas encore prioritaire.

!!! warning "Difficultés rencontrées"
    - Il reste complexe de s'assurer qu'un même évènement ne puisse pas être créé pour un même créneau horaire, au même endroit et sur la même infrastructure. Une logique de vérification supplémentaire devra être mise en place pour éviter ces doublons.

!!! abstract "Prochaines étapes"
    - Développer le mode vue de la page *Activités*.
    - Développer le mode vue de la page *Profil*.


---

## Semaine 10 (6-12 juillet)

??? note “Étapes faites”
    - [x] Développement du mode Vue liste et Vue carte de la page Activités.
    - [x] Ajout de la possibilité de voir les activités organisées, celles auxquelles l’utilisateur participe, et celles enregistrées pour plus tard.
    - [x] Début de l’intégration de la page Profil avec affichage des informations de base (nom, photo, sports favoris, disponibilités).

!!! info “Notes”
    - Les deux modes d’affichage (liste et carte) sont désormais fonctionnels sur la page Activités, avec un filtrage par sport et par date similaire à celui de la page Explorer.
    - L’affichage des activités auxquelles l’utilisateur participe reprend le design de celles qu’il organise, mais sans les options de modification.
    - Sur la page Profil, l’intégration a débuté avec une photo de profil modifiable et des sections préparées pour les sports favoris et les disponibilités, qui seront reliées à la base de données lors d’une prochaine étape.

!!! warning “Difficultés rencontrées”
    - Quelques lenteurs ont été observées lors du chargement initial des activités lorsque la base de données contient un volume important d’entrées.
    - La synchronisation en temps réel des données de profil avec Firebase n’est pas encore stable, ce qui provoque parfois un affichage obsolète après modification.

!!! abstract “Prochaines étapes”
    - Finaliser la page Profil avec édition des sports favoris et des disponibilités.
    - Optimiser les requêtes Firebase pour réduire le temps de chargement des activités.
    - Commencer la mise en page et l’intégration de la page Home.

    

--- 

## Semaine 11 (13-19 juillet)

## Semaine 12 (20-26 juillet)

## Semaine 13 (27 juillet au 2 août)
