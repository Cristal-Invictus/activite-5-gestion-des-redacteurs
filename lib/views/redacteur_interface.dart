import 'package:flutter/material.dart';

import '../modele/redacteur.dart';
import '../services/database_manager.dart';

class RedacteurInterface extends StatefulWidget {
  const RedacteurInterface({super.key});

  @override
  State<RedacteurInterface> createState() => _RedacteurInterfaceState();
}

class _RedacteurInterfaceState extends State<RedacteurInterface> {
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _databaseManager = DatabaseManager.instance;

  List<Redacteur> _redacteurs = [];
  bool _chargement = true;

  @override
  void initState() {
    super.initState();
    _chargerRedacteurs();
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _chargerRedacteurs() async {
    try {
      final redacteurs = await _databaseManager.getAllRedacteurs();
      if (!mounted) return;

      setState(() {
        _redacteurs = redacteurs;
        _chargement = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _chargement = false);
      _afficherMessage('Impossible de charger les redacteurs.');
    }
  }

  Future<void> _ajouterRedacteur() async {
    final nom = _nomController.text.trim();
    final prenom = _prenomController.text.trim();
    final email = _emailController.text.trim();

    if (!_champsValides(nom, prenom, email)) {
      return;
    }

    final redacteur = Redacteur.sansId(
      nom: nom,
      prenom: prenom,
      email: email,
    );

    try {
      await _databaseManager.insertRedacteur(redacteur);
      _viderChamps();
      await _chargerRedacteurs();
      if (!mounted) return;
      _afficherMessage('Redacteur ajoute avec succes.');
    } catch (e) {
      if (!mounted) return;
      _afficherMessage('Echec de l\'ajout du redacteur.');
    }
  }

  Future<void> _ouvrirModification(Redacteur redacteur) async {
    final nomController = TextEditingController(text: redacteur.nom);
    final prenomController = TextEditingController(text: redacteur.prenom);
    final emailController = TextEditingController(text: redacteur.email);

    final enregistrer = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Modifier le redacteur'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Nom'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: prenomController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Prenom'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );

    if (enregistrer != true || !mounted) {
      nomController.dispose();
      prenomController.dispose();
      emailController.dispose();
      return;
    }

    final nom = nomController.text.trim();
    final prenom = prenomController.text.trim();
    final email = emailController.text.trim();

    nomController.dispose();
    prenomController.dispose();
    emailController.dispose();

    if (!_champsValides(nom, prenom, email)) {
      return;
    }

    try {
      await _databaseManager.updateRedacteur(
        Redacteur(
          id: redacteur.id,
          nom: nom,
          prenom: prenom,
          email: email,
        ),
      );
      await _chargerRedacteurs();
      if (!mounted) return;
      _afficherMessage('Redacteur modifie avec succes.');
    } catch (e) {
      if (!mounted) return;
      _afficherMessage('Echec de la modification.');
    }
  }

  Future<void> _confirmerSuppression(Redacteur redacteur) async {
    final confirmer = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Supprimer le redacteur'),
          content: Text(
            'Voulez-vous vraiment supprimer ${redacteur.prenom} ${redacteur.nom} ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );

    final id = redacteur.id;
    if (confirmer != true || id == null) {
      return;
    }

    try {
      await _databaseManager.deleteRedacteur(id);
      await _chargerRedacteurs();
      if (!mounted) return;
      _afficherMessage('Redacteur supprime.');
    } catch (e) {
      if (!mounted) return;
      _afficherMessage('Echec de la suppression.');
    }
  }

  bool _champsValides(String nom, String prenom, String email) {
    if (nom.isEmpty || prenom.isEmpty || email.isEmpty) {
      _afficherMessage('Veuillez remplir tous les champs.');
      return false;
    }

    final emailValide = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
    if (!emailValide) {
      _afficherMessage('Veuillez saisir une adresse e-mail valide.');
      return false;
    }

    return true;
  }

  void _viderChamps() {
    _nomController.clear();
    _prenomController.clear();
    _emailController.clear();
    FocusScope.of(context).unfocus();
  }

  void _afficherMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des redacteurs'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _nomController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _prenomController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Prenom',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _ajouterRedacteur(),
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _ajouterRedacteur,
                  icon: const Icon(Icons.person_add_alt_1),
                  label: const Text('Ajouter un redacteur'),
                ),
              ),
              const SizedBox(height: 18),
              const Divider(),
              const SizedBox(height: 8),
              Expanded(child: _construireListe()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construireListe() {
    if (_chargement) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_redacteurs.isEmpty) {
      return const Center(
        child: Text(
          'Aucun redacteur enregistre.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      itemCount: _redacteurs.length,
      itemBuilder: (context, index) {
        final redacteur = _redacteurs[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                redacteur.prenom.isNotEmpty
                    ? redacteur.prenom[0].toUpperCase()
                    : '?',
              ),
            ),
            title: Text('${redacteur.prenom} ${redacteur.nom}'),
            subtitle: Text(redacteur.email),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Modifier',
                  onPressed: () => _ouvrirModification(redacteur),
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: 'Supprimer',
                  onPressed: () => _confirmerSuppression(redacteur),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
