# Études préliminaires

## Analyse du problème

Lors de notre étude préliminaire, une problématique importante a émergé concernant les choix technologiques à adopter pour la conception de l’application. Plus précisément, le doute portait sur l’interface et le langage de programmation à utiliser selon la ou les plateformes ciblées. En effet, nous nous sommes interrogés sur l’approche à privilégier : développer une application native pour Android, une autre pour iOS, ou opter pour une solution multiplateforme.


## Exigences

**Exigences fonctionnelles :**

- L’application doit permettre à l’utilisateur de créer un compte et gérer son profil.
- L’utilisateur peut visualiser une carte des activités sportives disponibles autour de lui selon un rayon fixe qu'il peut modifier mais qui ne peut pas être plus grand que les limites de sa ville où il réside.
- Il peut créer, rejoindre et gérer des activités sportifs.
- Un calendrier permet à l’utilisateur de suivre ses activités prévues.
- Un système de messagerie ou de contact entre utilisateurs est disponible.
- L’application doit être disponible sur les appareils iOS. (*est-ce une exigence fonctionnelle?*)

**Exigences non fonctionnelles :**

- L’application doit offrir une interface utilisateur fluide, rapide, intuitive et minimaliste.
- L’application doit tirer parti des composants natifs d’iOS (comme la localisation, le calendrier, les notifications).
- Le code doit être écrit en Swift pour profiter des performances et de la stabilité du langage natif.
- La compatibilité est assurée uniquement pour iOS 18 et plus, pour simplifier la gestion des versions (justification ici https://developer.apple.com/support/app-store/).
- Le développement doit respecter un échéancier serré, donc cibler une seule plateforme réduit le temps et la complexité.
- L’application ne doit pas dépendre de bibliothèques multiplateformes tierces, afin de garder un contrôle total sur l’interface et la performance (donc autre que SwiftUI, les Swift Core Libraries et les librairies de Firebase)

## Recherche de solutions

(**Avant la rencontre du 13 mai**) Ces réflexions nous ont amenés à revoir nos exigences initiales, afin d’assurer une meilleure cohérence avec nos objectifs et nos ressources. Après discussion, nous avons conclu que l’application serait disponible uniquement sur les appareils Apple (iOS). Cette décision repose principalement sur notre volonté de livrer une application la plus riche et fluide possible, en misant pleinement sur nos compétences existantes avec le langage Swift. En nous concentrant sur une seule plateforme, nous maximisons la qualité de l’expérience utilisateur tout en optimisant le temps de développement. Le développement sur Android pourrait éventuellement considéré mais ce n'est pas l'objectif de ce projet.

## Réflexion sur les exigences fonctionnelles (rencontre du 13 mai)
### Calendrier
Il était prévu d'intégrer un calendrier directement dans l'application. Finalement, cette option a été écartée pour deux raisons principales.

- Temps de développement : Intégrier un calendrier natif ralentirai considérablement le développement et ce, pour un bénéfice qui n'en vaudrait pas les efforts.

- Expérience utilisateur : Lors de la première utilisation, l'utilisateur se retrouverait avec un calendrier vide, ce qui renvoie une impression de solitude. Cela va à l'encontre de l'objectif principal de l'application qui est d'aider les gens à rencontrer d'autres pratiquants un sport.

La solution proposée est la suivante. Il faudrait permettre la création automatique d'événements dans des applications existantes comme Apple Calendar ou Google Calendar. Ainsi, l'utilisateur peut facilement voir si une quelconque activité s'intègre à son emploi du temps (à condition bien sûr qu'il est l'une d'entre elles).

### Messagerie
Suite à la rencontre numéro 2, une clarification s’impose concernant le fonctionnement de la messagerie privée. Après réflexion, nous avons conclu que puisque l’application n’est pas centrée sur la communication entre les utilisateurs, il ne sera pas possible d’envoyer des messages privés individuels, sauf bien sûr dans le cas d’activités à deux personnes

Lorsqu’un utilisateur s’inscrit à une activité ou à un événement, il sera automatiquement ajouté à une conversation de groupe liée à cet événement. Ainsi, tous les participants d’un même événement auront accès à un espace de discussion commun.

Par ailleurs, une autre question s’est posée : étant donné que la messagerie n’est pas une fonctionnalité centrale de l’application, est-il pertinent d’inclure une icône "inbox" dans la barre de menu principale ? Après réflexion, nous croyons que oui. Bien que la messagerie ne soit pas au cœur de l’application, elle reste un outil fréquemment utilisé par les utilisateurs pour recevoir des informations importantes liées aux événements ou aux activités auxquels ils participent.

### Explore - Carte
Deux options concernant l'implémentation de la carte s'ouvre à nous. En fait, la 2e option sera choisite uniquement s'il est impossible de trouver une API qui nous fournit de l'information à propos des infrastructures de sports. Les deux options auraient la composante "temporal slider" par un intervalle de temps X (*à décider*)

- Option 1 : L'idée principale est d'afficher tous les marqueurs qui chacun, correspond à une infrastructure du sport choisi par l'utilisateur (dans le filtre convenu), sur la carte. De ce fait, même si aucune activité n'a été créée à une infrastructure X, l'utilisateur pourrait tout de même profiter des marqueurs afin de créer une nouvelle activité, sans qu'il est besoin de chercher sur Internet quels terrains ou centres de sports s'offrent à lui (dans le rayon sélectionné).

- Option 2 : Dans ce scénario, des marqueurs ne seront affichés uniquement si une activité y a été crée. Il n'y aura donc pas la fonctionnalité de créer une activité directement sur la carte, en sélectionnant un marqueur. Cela impose également que l'utilisateur doit faire ses recherches à priori pour trouver quelle infrastructure peut organiser son activité.

Pour faciliter l'expérience utilisateur, nous ajouterons également un bouton qui permet d'afficher uniquement les marqueurs qui ont des activités d'organiser. Cela permet d'éviter que l'utilisateur entre dans le scénario suivant : je cherche des activités mais quand je clique un marqueur, rien n'y est affiché. 

#### Suivi (en date du 18 mai)
- Option 1 : Après plusieurs recherches, il est clair que se fier sur les données ouvertes des grandes villes rendrait la tâche trop complexe. Alors, le choix s'imposerait entre Google Map API ou OpenStreetMap API. L'API de Google Map est limité sur l'identification des installations sportives. Cependant, l'API de OSM est plutôt intéressante même si elle pourrait ne pas être performante pour de plus petites villes. En effet, elle propose un tag `sport=*` (voir https://wiki.openstreetmap.org/wiki/Key:sport). Une deuxième chose à considérer est que OSM recommande généralement de ne pas dépasser 10 000 requêtes/jour. Cela ne risque pas d'être un problème pour nous au départ mais dans un certain futur, il faudrait considérer la mise en cache locale avec SwiftData.

### Explore - Liste
Une clarification s’imposait concernant la liste des activités. Cette liste représente une vue en format texte des activités affichés sur la carte. Elle est triée en fonction de la distance par rapport à l’adresse indiquée dans le profil de l’utilisateur. Seuls les activités situés dans la même ville que celle de l’adresse fournie y sont affichés.

Une option de géolocalisation pourrait éventuellement être envisagée afin d’offrir plus de flexibilité dans l’affichage des activités à proximité.

### Authentification
En reconsultant la page de création d'un compte à partir du prototype Figma, nous nous sommes rendus compte qu'elle était trop longue et que cette étape diminueraient non seulement l'efficience du processus d'enregistrement mais également la satisfaction d'utilisateur. C'est pourquoi il serait préférable de déplacer toutes les spécifications, après les champs de texte sur le courriel et le mot de passe, dans la configuration du profil une fois l'utilisateur connecté.

## Méthodologie
### Choix technologiques et plateforme ciblée
Nous avons opté pour un développement **natif iOS en Swift**, pour :
- Utilisation de `Xcode` comme IDE pour le code et la simulation en temps réelle
    - Tirer parti des composants natifs (localisation, notifications)
    - Cibler uniquement iOS 17+ pour simplifier les tests https://developer.apple.com/support/app-store/ [_Statistiques de répartition des versions iOS_]
- Utilisation du framework `SwiftUI` afin de bénéficier de la stabilité et des performances natives
- Utilisation de `Firebase` pour le backend, plus exactement `Cloud Firestore`

### Collecte des données
Notre collecte des données publiques se fera principalement à partir de l'API OpenStreetMap. Celle-ci nous permettra de recueillir toutes sortes d'information à propos des emplacements sportifs ; coordonnées (latitude/longitude), type de terrain (e.g. soccer, basketball, volleyball), les limites de l'emplacement, le nom de l'infrastructure ou du parc (si s'applique), etc.

Concernant les données personnelles des utilisateurs, nous appliquons un principe de minimisation et de consentement éclairé :

- **Informations de compte** : nom complet, adresse courriel, mot de passe (encrypté), pseudonyme, préférences sportives et photo de profil

- **Données d’activité** : participants et avis des participants sur la performance des autres joueurs à la suite d'une activité, potentiellement des traces GPS si le temps nous le permet