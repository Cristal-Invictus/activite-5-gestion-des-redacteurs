import 'package:activite_5_gestion_des_redacteurs/modele/redacteur.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Redacteur', () {
    test('toMap ignore id quand il est absent', () {
      const redacteur = Redacteur.sansId(
        nom: 'Dupont',
        prenom: 'Alice',
        email: 'alice@example.com',
      );

      expect(redacteur.toMap(), {
        'nom': 'Dupont',
        'prenom': 'Alice',
        'email': 'alice@example.com',
      });
    });

    test('fromMap reconstruit un redacteur', () {
      final redacteur = Redacteur.fromMap({
        'id': 7,
        'nom': 'Martin',
        'prenom': 'Yann',
        'email': 'yann@example.com',
      });

      expect(redacteur.id, 7);
      expect(redacteur.nom, 'Martin');
      expect(redacteur.prenom, 'Yann');
      expect(redacteur.email, 'yann@example.com');
    });
  });
}
