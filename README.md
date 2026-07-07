# Allumettes — Jeu en Ada

Implémentation du jeu des allumettes (Nim game) en langage Ada.

## Règles
Deux joueurs retirent tour à tour 1, 2 ou 3 allumettes dun tas. Le joueur qui prend la dernière allumette perd.

## Tech Stack
- Ada
- Shell scripts (tests)

## Structure
| Fichier | Description |
|---------|-------------|
| `allumettes.adb` | Logique principale du jeu |
| `alea.ads / alea.adb` | Module de génération aléatoire |
| `exemple_alea.adb` | Exemple dutilisation |

## Compilation
```bash
gnatmake allumettes.adb
./allumettes
```