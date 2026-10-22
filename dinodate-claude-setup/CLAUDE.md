# DinoDate

Puzzle-platformer 2D pixel art en co-op local, fait avec Godot 4.5 (GDScript).
Objectif : shipper gratuitement sur itch.io, build Web d'abord.
Développeur : Oliver, débutant en GDScript. Il garde la main sur le code et veut apprendre en le faisant.

## État du projet (à revérifier, le dépôt peut avoir bougé)
- `levels/level_1..16.tscn` : un niveau par scène. Chaque niveau contient un nœud `GameManager`.
- `script/` : game_manager, platform_goal, killzone, level_display, player_oneMovement, player_twoMovement, platformsBlink, platformsSwitch, platformsSwitchInvis, save_system.
- `scenes/` : bgm, joueurs, plateformes, killzone, label_level, platformGoal.
- Autoloads : `Bgm` (scenes/bgm.tscn) et `SaveSystem` (script/save_system.gd).
- Entrées : jump01 / move_left01 / move_right01 (joueur 1), jump02 / move_left02 / move_right02 (joueur 2), restartGame.
- `addons/gamedev_assistant` : plugin d'éditeur tiers. Ne pas le modifier.
- `index.*` à la racine : ancien export Web commité.

## Façon de travailler (important)
Oliver veut garder la main. Claude explique et propose, Oliver décide.

1. Avant toute modification : expliquer en 3 à 6 lignes le pourquoi, les fichiers touchés et l'impact. Attendre le OK.
2. Un changement = une intention. Maximum 3 fichiers et environ 80 lignes. Au-delà, découper en étapes.
3. Ne jamais renommer, déplacer, supprimer ni reformater du code existant sans demande explicite. Les problèmes repérés en passant sont listés à la fin, pas corrigés.
4. Chaque concept nouveau : 2 à 3 lignes d'explication (analogie ou pseudo-code) et le nom de la page de doc Godot concernée.
5. Signaler dès qu'une approche nuit à la scalabilité : copier-coller sur 16 niveaux, dépendances en dur, état global.
6. Git : ne jamais commit, push, merge, reset ni changer de branche sans demande. Proposer un message de commit à la fin. Travailler sur une branche `feat/<tâche>`.
7. Ne pas toucher à `project.godot`, `export_presets.cfg`, `addons/`, `index.*` sans demande explicite. Montrer le diff avant.
8. Si une demande est ambiguë, ou si la réponse d'Oliver est incomplète ou fausse : poser une question et creuser, ne pas valider par défaut.

## Conventions de code
Le détail est dans `.claude/rules/gdscript.md` (chargé dès qu'un `.gd` est lu) et `.claude/rules/scenes-and-export.md`.
Résumé : GDScript typé, snake_case, un script = une responsabilité, signaux vers le haut et appels vers le bas, pas de nombre magique, commentaires en français qui expliquent le pourquoi.

## Dette technique connue (ne pas corriger sans demande)
- `game_manager.gd` crée une 2e instance de SaveSystem malgré l'autoload, et redirige vers le niveau sauvegardé à chaque ouverture de niveau.
- `platform_goal.gd` : la fin du niveau 16 remet la sauvegarde à 1. Le ralenti `Engine.time_scale = 0.1` affecte aussi les timers.
- Nommage mixte : `player_oneMovement`, `platformsHorizBlink.tscn`, variable `blueOnGoal`.
- Pas de menu : `run/main_scene` pointe sur `level_1`.
- Export : chemins de build propres à la machine d'Oliver, pas de preset Linux, addon non exclu du build, build Web commité à la racine.
- `music/ep-theme4.wav` (14,6 Mo, non compressé) à convertir en `.ogg`.

## Feuille de route
La source de vérité est la base Tâches de Notion (projet « Puzzle-platformer (Godot 4) »).
1. Menu principal
2. Sauvegarde : étendre l'existant
3. Scoreboard (temps par niveau, local)
4. Test complet des 16 niveaux + bugs
5. Exports Web / Windows / Linux
6. Page itch.io + publication

Avant une tâche : lire sa fiche Notion et son critère de réussite si le connecteur Notion est actif. Sinon, demander le critère à Oliver.

## Définition de « terminé »
- Le projet se charge sans erreur de script.
- Le critère de réussite est vérifié, avec une procédure de test en 3 à 5 étapes pour Oliver dans l'éditeur.
- Plus de `print` de debug oublié, plus de code commenté.
- Résumé du diff et message de commit proposé.

## Commandes (à valider au premier lancement)
- Lancer le jeu : `godot --path .` ou F5 dans l'éditeur.
- Charger le projet sans fenêtre : `godot --headless --path . --quit`
- Vérifier la syntaxe d'un script : `godot --headless --path . --check-only --script res://script/<fichier>.gd`
- Si le binaire s'appelle autrement (`godot4`, Flatpak), demander le nom à Oliver.

## Commandes slash du projet
- `/plan-task <tâche>` : plan sans modification de fichier.
- `/review-junior` : relecture du diff selon les conventions.
- `/wrap-task <tâche>` : vérification de fin de tâche, commit et Notion proposés.
