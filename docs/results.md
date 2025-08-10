# Résultats

## Fonctionnalités

- *Authentification complète* : inscription avec nom, courriel, mot de passe, sports favoris, disponibilités et photo optionnelle ; connexion sécurisée ; gestion et mise à jour du profil via Firebase Authentication, Firestore et Storage.
- *Profil utilisateur* : affichage des informations personnelles, sports favoris, disponibilités hebdomadaires, photo de profil (téléchargée ou par défaut) et possibilité de déconnexion.
- *Carte interactive* : exploration des infrastructures sportives avec filtres par sport et date, marqueurs personnalisés, gestion multi-sports et zoom adaptatif.
- *Recherche et filtrage d’activités* : affichage sous forme de carte ou de liste, tri par date ou distance, exclusion des activités déjà organisées ou rejointes.
- *Création d’activités sportives* : formulaire structuré (titre, sport, lieu, date, horaires, participants, description, invitations), validation des champs, vérification des conflits horaires et enregistrement dans Firestore avec image d’aperçu de la carte.
- *Gestion des activités* : affichage et modification des activités organisées ; vue des activités auxquelles l’utilisateur participe ou qu’il a enregistrées.
- *Recommandations* : mise en avant d’activités suggérées à l’accueil, pouvant à terme s’adapter aux préférences sportives et disponibilités de l’utilisateur.
- *Données en temps réel* : synchronisation dynamique des activités et de la participation grâce à Firebase.
- *Accessibilité* : compatibilité avec VoiceOver et ajout de descriptions accessibles aux éléments interactifs.

## Démonstration


Voici notre vue de l’écran de démarrage (splash screen) :

![Splash Screen](./screenshots/photo_splashscreen.png "Splash Screen"){ width="35%" }

Voici nos vues d’accueil:

![Accueil (bas)](./screenshots/photo_accueil_bas.png "Accueil (bas)"){ width="35%" }
![Accueil (haut)](./screenshots/photo_accueil_haut.png "Accueil (haut)"){ width="35%" }

Voici notre vue des détails d’activité:

![Détails activité (bas)](./screenshots/photo_activites_details_bas.png "Détails activité (bas)"){ width="35%" }
![Détails activité (haut)](./screenshots/photo_activites_details_haut.png "Détails activité (haut)"){ width="35%" }

Voici notre vue des activités organisées (Bookings — Hosting) :

![Bookings — Hosting](./screenshots/photo_bookings_hosting.png "Bookings — Hosting"){ width="35%" }

Voici notre vue de la carte avec filtres :

![Carte avec filtres](./screenshots/photo_carte_filtre.png "Carte avec filtres"){ width="35%" }

Voici notre vue de connexion :

![Connexion](./screenshots/photo_connexion.png "Connexion"){ width="35%" }

Voici nos vues de création d’activité:

![Créer activité (bas)](./screenshots/photo_creer_activite_bas.png "Créer activité (bas)"){ width="35%" }
![Créer activité (haut)](./screenshots/photo_creer_activite_haut.png "Créer activité (haut)"){ width="35%" }

Voici notre vue du panneau de filtres d’activités :

![Filtres d’activités](./screenshots/photo_filtre_activites.png "Filtres d’activités"){ width="35%" }

Voici nos vues d’inscription — choix des sports, (formulaire principal)  :

![Inscription](./screenshots/photo_inscription.png "Inscription"){ width="35%" }
![Inscription — sports favoris](./screenshots/photo_inscription_sports.png "Inscription — sports favoris"){ width="35%" }


Voici nos vues d’inscription — disponibilités, ajout de photo de profil:

![Inscription — disponibilités](./screenshots/photo_inscription_disponibilites.png "Inscription — disponibilités"){ width="35%" }
![Inscription — photo de profil](./screenshots/photo_inscription_photoprofil.png "Inscription — photo de profil"){ width="35%" }


Voici nos vues de la liste avec filtres :

![Liste avec filtres](./screenshots/photo_liste_filtre.png "Liste avec filtres"){ width="35%" }

Voici nos vues de modification d’une activité :

![Modifier activité](./screenshots/photo_modifier_activite.png "Modifier activité"){ width="35%" }

Voici nos vues de profil :

![Profil](./screenshots/photo_profil.png "Profil"){ width="35%" }

## Bilan

Dans l’ensemble, le projet a permis d’atteindre la grande majorité des objectifs fixés en début de développement. Les fonctionnalités essentielles au fonctionnement de l’application sont opérationnelles : authentification, gestion de profil de base, création et exploration d’activités, affichage des cartes interactives, et mise à jour en temps réel des données via Firebase. Les parcours principaux ont été testés et validés, assurant ainsi une expérience utilisateur fluide et cohérente.

Cependant, certaines fonctionnalités prévues n’ont pas encore été finalisées. C’est notamment le cas :
- du système de messagerie intégré,
- de la page Home dans sa version définitive,
- de la modification complète du profil utilisateur,
- et du système de pointage compétitif pleinement fonctionnel.

Ces éléments, bien que non essentiels au déploiement minimal de l’application, font partie des évolutions importantes identifiées pour améliorer l’engagement des utilisateurs et enrichir l’expérience globale. Leur intégration future permettra de se rapprocher encore davantage de la vision initiale, tout en consolidant la position de l’application dans son domaine d’utilisation.
