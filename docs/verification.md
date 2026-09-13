# Verification de l'activite

## Checklist fonctionnelle

- [x] Classe `Redacteur` avec `id`, `nom`, `prenom` et `email`.
- [x] Deux constructeurs, dont un sans `id`.
- [x] Conversion `toMap()` et reconstruction `fromMap()`.
- [x] Base locale SQLite `redacteurs.db`.
- [x] Table `redacteurs` avec cle primaire auto-incrementee.
- [x] Methodes `getAllRedacteurs`, `insertRedacteur`, `updateRedacteur`, `deleteRedacteur`.
- [x] `MonApplication` retourne un `MaterialApp`.
- [x] `RedacteurInterface` est un `StatefulWidget`.
- [x] Champs Nom, Prenom et E-mail controles par des `TextEditingController`.
- [x] Ajout d'un redacteur et rafraichissement de la liste.
- [x] Modification via `AlertDialog`.
- [x] Suppression apres confirmation.
- [x] Affichage dynamique avec `ListView.builder`.
- [x] Chargement initial des donnees avec `initState()`.
- [x] Validation simple de l'e-mail et messages utilisateur.

## Tests a effectuer sur un poste Flutter

1. Executer `flutter pub get`.
2. Si necessaire, executer `flutter create . --platforms=android` pour regenerer les fichiers Android.
3. Executer `flutter analyze`.
4. Executer `flutter test`.
5. Lancer l'application sur un emulateur ou un appareil Android.
6. Ajouter au moins deux redacteurs.
7. Fermer puis relancer l'application afin de verifier la persistance.
8. Modifier un redacteur.
9. Supprimer un redacteur et verifier la demande de confirmation.
