---
paths:
  - "**/*.tscn"
  - "project.godot"
  - "export_presets.cfg"
---

# Scènes, projet et export

## Scènes (.tscn)
- Ne pas éditer un `.tscn` à la main, sauf changement trivial d'une propriété. Pour le reste, donner à Oliver les étapes à faire dans l'éditeur Godot : il garde la main et on évite d'abîmer les UID.
- Une scène modifiée depuis le terminal doit être fermée dans Godot, sinon l'éditeur peut écraser la modification en sauvegardant.
- Les 16 niveaux partagent la même structure. Tout changement de structure se propose dans une scène commune, pas en 16 éditions.

## Export Web (cible itch.io)
- Pas de threads (`variant/thread_support=false` est déjà en place). Le Web utilise le renderer Compatibility.
- Pas de bouton Quitter sur le Web : tester `OS.has_feature("web")`.
- Limites itch.io : 500 Mo au total, 200 Mo par fichier, 1000 fichiers. `index.html` à la racine de l'archive.
- Audio : préférer `.ogg` à `.wav`.
- Chemins d'export relatifs au dépôt, jamais liés à une machine.

## Fichiers sensibles
- `project.godot` et `export_presets.cfg` : modifier seulement sur demande, et montrer le diff avant d'écrire.
