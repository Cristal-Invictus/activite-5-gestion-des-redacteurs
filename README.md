# Activite 5 - Gestion des redacteurs

Application Flutter realisee pour l'activite de developpement mobile consacree a la gestion des donnees locales avec Sqflite.

## Fonctionnalites

- ajout d'un redacteur avec nom, prenom et e-mail ;
- affichage de la liste des redacteurs enregistres ;
- modification d'un redacteur dans une boite de dialogue ;
- suppression apres confirmation ;
- chargement automatique des donnees avec `initState()` ;
- stockage local SQLite avec `sqflite` ;
- validation simple des champs et messages `SnackBar`.

## Organisation

```text
lib/
  main.dart
  modele/
    redacteur.dart
  services/
    database_manager.dart
  views/
    redacteur_interface.dart
```

## Dependances principales

- `sqflite`
- `path`

## Lancement

Sur une machine avec Flutter installe :

```bash
flutter pub get
flutter create . --platforms=android
flutter run
```

La commande `flutter create . --platforms=android` est utile uniquement si les fichiers de plateforme Android ne sont pas deja presents dans votre environnement de travail.

## Verification

```bash
flutter analyze
flutter test
```

## Base de donnees

La base `redacteurs.db` contient une table `redacteurs` avec :

- `id` : `INTEGER PRIMARY KEY AUTOINCREMENT`
- `nom` : `TEXT NOT NULL`
- `prenom` : `TEXT NOT NULL`
- `email` : `TEXT NOT NULL`
