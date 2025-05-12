# Études préliminaires

## Analyse du problème

Lors de notre étude préliminaire, une problématique importante a émergé concernant les choix technologiques à adopter pour la conception de l’application. Plus précisément, le doute portait sur l’interface et le langage de programmation à utiliser selon la ou les plateformes ciblées. En effet, nous nous sommes interrogés sur l’approche à privilégier : développer une application native pour Android, une autre pour iOS, ou opter pour une solution multiplateforme.


## Exigences

**Exigences fonctionnelles :**

- L’application doit permettre à l’utilisateur de créer un compte et gérer son profil.
- L’utilisateur peut visualiser une carte des activités sportives disponibles autour de lui.
- Il peut créer, rejoindre et gérer des événements sportifs.
- Un calendrier permet à l’utilisateur de suivre ses activités prévues.
- Un système de messagerie ou de contact entre utilisateurs est disponible.
- L’application doit être disponible sur les appareils iOS.

**Exigences non fonctionnelles :**

- L’application doit offrir une interface utilisateur fluide, rapide et intuitive.
- L’application doit tirer parti des composants natifs d’iOS (comme la localisation, le calendrier, les notifications).
- Le code doit être écrit en Swift pour profiter des performances et de la stabilité du langage natif.
- La compatibilité est assurée uniquement pour iOS 15 et plus, pour simplifier la gestion des versions.
- Le développement doit respecter un échéancier serré, donc cibler une seule plateforme réduit le temps et la complexité.
- L’application ne doit pas dépendre de bibliothèques multiplateformes tierces, afin de garder un contrôle total sur l’interface et la performance.

## Recherche de solutions

Ces réflexions nous ont amenés à revoir nos exigences initiales, afin d’assurer une meilleure cohérence avec nos objectifs et nos ressources. Après discussion, nous avons conclu que l’application serait disponible uniquement sur les appareils Apple (iOS). Cette décision repose principalement sur notre volonté de livrer une application la plus riche et fluide possible, en misant pleinement sur nos compétences existantes avec le langage Swift. En nous concentrant sur une seule plateforme, nous maximisons la qualité de l’expérience utilisateur tout en optimisant le temps de développement.

## Méthodologie

