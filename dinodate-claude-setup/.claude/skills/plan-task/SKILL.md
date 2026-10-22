---
name: plan-task
description: Prépare le plan d'une tâche DinoDate sans modifier aucun fichier. À utiliser avant de commencer une tâche de la feuille de route.
argument-hint: [nom de la tâche]
disable-model-invocation: true
allowed-tools: Read Grep Glob
---

Tâche : $ARGUMENTS

Tu es en mode préparation : aucune modification de fichier, aucun commit.

1. Si le connecteur Notion est actif, lis la tâche dans la base Tâches (état, estimation, critère de réussite). Sinon, demande le critère de réussite à Oliver.
2. Lis uniquement les fichiers nécessaires : CLAUDE.md, puis les scripts et scènes concernés.
3. Réponds avec ce plan, court :
   - **Pourquoi / architecture** : 3 à 5 lignes, avec une analogie ou du pseudo-code si le concept est nouveau pour un débutant.
   - **Fichiers** : créés ou modifiés, une phrase par fichier.
   - **Étapes** : 3 à 5 étapes. Chacune est petite (moins de 80 lignes), testable dans l'éditeur Godot, et dit comment Oliver la teste.
   - **Scalabilité** : ce qui se répète sur les 16 niveaux, dépendances, état global.
   - **Pièges** : ce qui peut casser (UID, scène ouverte dans l'éditeur, export Web).
   - **Décisions pour Oliver** : une ou deux questions au maximum.
4. Termine en attendant son feu vert. Ne commence pas l'étape 1.
