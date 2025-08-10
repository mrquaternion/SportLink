# Évaluation

## Plan de test
Le plan de test comprenait trois volets :

- Tests unitaires et fonctionnels réalisés avec le framework XCTest, couvrant la conversion d’objets, le calcul de distances, l’initialisation des ViewModels, ainsi que la validation des parcours critiques (création de compte, connexion valide ou invalide). Un test de performance a également été ajouté pour mesurer la réactivité de l’application face à des événements rapides.
- Tests de performance évaluant la consommation de ressources (CPU, RAM) lors d’animations, de changements de vues et de la génération de cartes.
- Tests d’utilisabilité menés auprès de trois utilisateurs cibles, dans un contexte semi-contrôlé, sur deux tâches principales (Créer un compte et Créer une activité), avec collecte de données quantitatives (nombre de clics, temps, erreurs) et qualitatives (commentaires).à

Un contrôle de l’accessibilité a également été effectué avec Accessibility Inspector pour garantir la compatibilité avec les technologies d’assistance.

## Critères d'évaluation

- Fonctionnalité : toutes les étapes critiques des parcours utilisateurs doivent pouvoir être complétées sans blocage.
- Performance : l’application doit maintenir une utilisation CPU inférieure à 40 % sur au moins 4 cœurs et éviter toute surconsommation de RAM lors d’animations ou de changements de vues.
- Utilisabilité : le temps d’exécution des tâches et le nombre de clics doivent rester proches des standards observés dans des applications similaires, avec un minimum d’erreurs et une bonne compréhension des interactions.
- Accessibilité : tous les éléments interactifs doivent être utilisables avec VoiceOver et disposer de descriptions adaptées.
- Satisfaction utilisateur : la majorité des participants doivent indiquer être « d’accord » ou « tout à fait d’accord » avec les affirmations positives sur la facilité d’utilisation, la clarté de l’interface et le sentiment de contrôle.

## Analyse des résultats

Les tests unitaires et fonctionnels montrent que les parcours critiques sont bien couverts, bien que certaines fonctionnalités clés (création complète d’activité, gestion des invitations) restent à automatiser. Les mesures de performance indiquent une utilisation CPU moyenne entre 25 % et 35 % sur 4 cœurs, confirmant que l’application peut fonctionner sur des iPhones plus anciens supportant iOS 17.
Les tests d’utilisabilité révèlent une excellente fluidité lors de la création de compte (18 clics, 1 min 25 s, aucune erreur), mais identifient une friction lors de la création d’activité (22 clics, 3 min 08 s, erreurs liées à la sélection du lieu). Les ajustements apportés (instructions contextuelles, meilleure distinction des marqueurs, feedback visuel renforcé) devraient améliorer cette étape.
L’accessibilité est jugée satisfaisante grâce aux descriptions ajoutées pour VoiceOver, bien qu’une surveillance continue soit nécessaire pour maintenir cette conformité.
La grille de satisfaction confirme une appréciation globale élevée, tout en soulignant la nécessité d’améliorer certains retours visuels et messages d’erreur pour optimiser la clarté et réduire les hésitations.
