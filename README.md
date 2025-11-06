# Ametask

Ametask est une applcation de gestion de liste de tâches réalisée en Dart avec le framework Flutter.
Les données sont stockées en local sur le téléphone en utilisant la bibliothèque [sqflite](https://pub.dev/packages/sqflite

Ce projet est pour le moment une ébauche qui m'a permis de découvrir une nouvelle technologie.

## Instalation

Pour le moment, Ametask n'est pas officiellement distribuée, il reste néanmoins possible de
construire l'application mobile en utilisant flutter ```flutter build apk```

## Présentation des pages

### Accueil

La page d'accueil permet de visualiser l'ensemble des listes de tâches, en les organisant par ordre
de dernière modification.

Cette page prévoit aussi d'autres éléments tels qu'un menu de navigation ou une barre de recherche qui ppourront servir à l'implémentation
de fonctionnalités futures plus complexes.

### Liste de tâches

Cette page permet d'avoir une vue d'ensemble de la liste de tâches sélectionnée ainsi que d'effectuer les modifications souhaitées.

Les élements modifiables sont le nom de la liste de tâche ainsi que sa description.

L'utilisateur peut également acceder à un menu pop-up affichant des informations supplémentaires sur la liste de taches.

La liste de tâches présente aussi la liste des taches qu'elle contient. Des bouttons présents en bas de la page permettent également
de gérer des opéations rapides pour les liste de tâches comportant un grand nombre de tâches à gérer.

### Tâche

Cette page permet d'avoir une vue d'ensemble de la tâche sélectionnée ainsi que d'effectuer les modifications souhaitées.

L'utilisateur à la possibilité de modifier le nom de la tâche, ainsi que sa description. Il peut également modifié sa 
"priorité" qui permet de monter ou descendre une tâche dans la liste par rapport aux autres.

Les tâches peuvent être de deux types : validable ou numérotable. Une tâche validable possède seulement deux états : finie ou non.
Tandis qu'une tâche numérotable permet de rentrer une valeur à atteindre, pouvant par exemple représenter un nombre d'itération de la 
tâche à éxecuter.
