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

## Semaine 10 (6-12 juillet)..

??? note "Étapes faites"
    - [x] La vue de la page *Activités* est terminée
    - [x] Une logique de vérification a été trouvé pour s'assurer qu'un même évènement ne puisse pas être créé pour un même créneau horaire, au même endroit et sur la même infrastructure.


!!! info "Notes"
    - La vue *Activités* doit être dveloppé pour intégrer une vue de modification pour les activité organisée
    - L’affichage des activités auxquelles l’utilisateur participe ou enregistre reprend le design de celles qu’il organise, mais sans les options de modification.
    - La vue *Profil* n'a pas été fait

!!! warning "Difficultés rencontrées"
    - Nous avons eu certaine difficulté ou niveau de l'enregistrement d'une activité créer dans la base de donnée Firebase et ensuite l'affiché dans la section activité organisées. Nous n'avons eu la chance ni le temps de mettre davantage de temps sur le problème cette semaine, mais nous ne pensons que cela sera un gros obstacle.

!!! abstract "Prochaines étapes"
    - Développer le mode vue de la page *Activités* au niveau de la modification.
    - Régler la logique d'enregistrement des données avec Firebase
    - Faire la vue "liste" de mode *Explorer*
    - Développer le mode vue de la page *Profil* (si le temps le permet).
    - Faire la vue *Home* (si le temps le permet)



--- 

## Semaine 11 (13-19 juillet)

??? note "Étapes faites"
    - [x] La vue de la page *Activités* est pour faire une modification est terminée
    - [x] Nous piuvons maintenant, afficher les activités organisées d'un utilisateur fictif dans la section des activités organisées


!!! info "Notes"
    - Même si on peut maintenat faire afficher les activités organisées, il faut implémenter aussi la logique de modification pour qu'elle puisse se syncroniser avec la base de données.
    - L’affichage des activités auxquelles l’utilisateur participe ou enregistre reprend le design de celles qu’il organise, mais sans les options de modification.
    - La vue *Profil* n'a pas été fait
    - La vue liste du mode *Explorer* est presque que terminée

!!! warning "Difficultés rencontrées"
    - Nous devons apporter une réflexion sur qu'est qui sera les filtre des recherches dans le mode *Explorer* et ce dans le mode carte et le mode liste. Comment l'afficher et quels filtres utilisés.
    - Nous n'avons pas eu le temps de toucher à la vue de la page *Profil* et la vue de la page *Home*

!!! abstract "Prochaines étapes"
    - Finir la vue liste du mode *Explorer*
    - Modifier les vue de la carte et de la liste du mode *Explorer* pour intégrer les filtres de recherche
    - Faire en sorte que de sycroniser les modifications des activités organisées avec la base de données.
    - Développer la vue de la page *Profil* (si le temps le permet).
    - Faire la vue *Home* (si le temps le permet)

---

## Semaine 12 (20-26 juillet)

??? note "Étapes faites"
    - [x] La vue *Explorer* est complètement terminé
    - [x] La modification d'une activité est maintenant possible.


!!! info "Notes"
    - Il faudra ajouter les vues des activités enregistrées et participées. Elles seront très semblables à ceux oragnaisées.

!!! warning "Difficultés rencontrées"
    - Nous tentons maintenant d'implémenter les fonctionnalités de connexion et de création de compte. Nous allons devoir lire quelques documentations afin de bien construire la logique et pour bien la syncroniser avec notre base de données.
    - Nous n'avons pas eu le temps de toucher à la vue de la page *Profil* et la vue de la page *Home*. La page *Profil* pourrait être abandonné pour la remise du rapport. 

!!! abstract "Prochaines étapes"
    - Implémenter les logiques de connexion et de création 
    - Une fois la logique de connexion implémentée, faire en sorte d'afficher pour l'utilisateur les activités, organisé, participé et enregistré.
     - Faire la vue *Home*
    - Développer la vue de la page *Profil* (si le temps le permet)

---

## Semaine 13 (27 juillet au 2 août)

??? note "Étapes faites"
    - [x] L'implémentation des logiques de connexion et de création 
    - [x] L'utilisateur connectée peut maintenant voir ses activités organisée et les activitées auquelles il participe.
    - [x] La vue *Home* est complété
    - [x] La vue *Profil* est complété


!!! info "Notes"
    - Les seules choses qui manqueraient avant la 2e foire sont, les activitées enregistrés, pouvoir modifier le profil et une page *Home* fonctionnelle et intéractive

!!! warning "Difficultés rencontrées"
    - Il nous manque du temps pour finaliser l'affichage des activités enregistrées. 

!!! abstract "Prochaines étapes"
    - Faire la foire et le rapport!
