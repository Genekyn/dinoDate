---
paths:
  - "**/*.gd"
---

# Conventions GDScript (lisible, niveau junior)

## Nommage
- Fichiers, variables, fonctions : `snake_case`. Classes et nœuds : `PascalCase`. Constantes : `UPPER_SNAKE_CASE`.
- Signaux au passé : `level_completed`, `player_died`. Booléens : `is_`, `has_`, `can_`.
- Nouveau fichier en `snake_case` (`main_menu.gd`). Ne pas renommer l'existant sans demande.

## Typage
- Typer les variables et les retours : `var speed: float = 200.0`, `func load_level(number: int) -> void:`
- `@export` pour ce qui se règle dans l'inspecteur, `@onready` pour les nœuds enfants.

## Structure
- Un script = une responsabilité. Repère : moins de 150 lignes par script, moins de 25 lignes par fonction.
- Ordre dans un fichier : `extends`, signaux, constantes, `@export`, variables, `@onready`, `_ready`, fonctions publiques, fonctions privées (préfixe `_`).
- Signaux vers le haut, appels vers le bas : l'enfant émet un signal, le parent appelle les méthodes de l'enfant.
- Pas de chemins fragiles du type `get_node("../../Autre")`. Utiliser un nom unique `%Nom` ou `@export var cible: Node`.
- Autoload seulement pour ce qui est vraiment global (SaveSystem, Bgm). Pas de nouvel autoload sans en discuter avec Oliver.
- Une logique utilisée par plusieurs niveaux vit dans un script partagé ou une scène instanciée, jamais copiée-collée dans les 16 niveaux.

## Lisibilité
- Pas de nombre magique : une constante nommée ou un `@export`.
- Commentaires en français qui expliquent le pourquoi, pas le quoi. Documenter les fonctions publiques avec `##`.
- Pas de `print` de debug dans le code terminé, pas de code commenté.

## Données et sauvegarde
- Fichiers dans `user://`, format ConfigFile ou JSON, avec une clé `version`.
- Fichier absent ou corrompu : retourner des valeurs par défaut, ne jamais planter.
- Ne jamais écrire dans `res://` pendant l'exécution (en lecture seule dans un build exporté).
