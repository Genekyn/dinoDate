---
name: wrap-task
description: Clôture une tâche DinoDate : vérifie le projet, résume le diff, propose le message de commit et les mises à jour Notion.
argument-hint: [nom de la tâche]
disable-model-invocation: true
allowed-tools: Bash(git status) Bash(git diff *) Bash(godot --headless --path . --quit) Read Grep
---

Clôture la tâche : $ARGUMENTS

1. Lance `godot --headless --path . --quit` et rapporte les erreurs de script telles quelles.
2. Relis le diff (`git diff`) et résume en 3 à 6 lignes ce qui a changé et pourquoi.
3. Vérifie la définition de « terminé » dans CLAUDE.md : `print` de debug, code commenté, critère de réussite.
4. Donne à Oliver la procédure pour tester le critère de réussite dans l'éditeur (3 à 5 étapes).
5. Propose un message de commit (une ligne à l'impératif, puis un corps court) et les mises à jour Notion (état de la tâche, temps réel passé).

N'exécute ni `git commit` ni la mise à jour Notion sans l'accord d'Oliver.
