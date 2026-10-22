---
name: review-junior
description: Relit le diff en cours selon les conventions DinoDate et classe les remarques, sans rien corriger.
disable-model-invocation: true
allowed-tools: Bash(git status) Bash(git diff *) Read Grep
---

Relis les changements en cours (`git status` et `git diff`) en les comparant à CLAUDE.md et à `.claude/rules/`.

Réponds avec trois listes courtes :

- **À corriger avant de continuer** : bug, plantage possible, sauvegarde non protégée, logique copiée-collée sur plusieurs niveaux.
- **À améliorer** : nommage, typage, fonction trop longue, nombre magique, commentaire manquant.
- **Bien fait** : un ou deux points concrets.

Pour chaque remarque : `fichier:ligne`, le problème en une phrase, le pourquoi, et la correction en pseudo-code ou en 2 à 3 lignes.
Ne modifie aucun fichier. Oliver décide ce qu'il corrige lui-même.
