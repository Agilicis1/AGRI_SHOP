import 'package:flutter/material.dart';
import 'adminHome.dart';
import 'gestionProduit.dart';
import 'gestionDesClients.dart';
import 'reLoadingImg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GestionDesCommandes extends StatefulWidget {
  @override
  _GestionDesCommandesState createState() => _GestionDesCommandesState();
}

class _GestionDesCommandesState extends State<GestionDesCommandes> {
  Future<List<dynamic>> fetchCommandes() async {
    final uri = Uri.parse('http://localhost:3000/api/orders');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur lors du chargement des commandes');
    }
  }

  Future<List<dynamic>> fetchUsers() async {
    final uri = Uri.parse('http://localhost:3000/api/users');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur lors du chargement des utilisateurs');
    }
  }

  late Future<List<dynamic>> commandesFuture;
  late Future<List<dynamic>> usersFuture;

  @override
  void initState() {
    super.initState();
    commandesFuture = fetchCommandes();
    usersFuture = fetchUsers();
  }

  Future<void> deleteCommande(String id) async {
    final uri = Uri.parse('http://localhost:3000/api/orders/$id');
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      setState(() {
        // On retire la commande supprimée de la liste locale pour un affichage instantané
        if (commandesFuture != null) {
          commandesFuture = commandesFuture.then((commandes) =>
            commandes.where((c) => (c['_id'] ?? c['id']) != id).toList()
          );
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Commande supprimée !'), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des commandes'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([commandesFuture, usersFuture]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data![0].isEmpty) {
            return Center(child: Text('Aucune commande trouvée.'));
          }
          final commandes = snapshot.data![0];
          final users = snapshot.data![1];

          String? getUserEmail(String userId) {
            final user = users.firstWhere(
              (u) => u['_id'] == userId || u['id'] == userId,
              orElse: () => null,
            );
            return user != null ? user['email'] ?? '' : '';
          }

          String? getUserName(String userId) {
            final user = users.firstWhere(
              (u) => u['_id'] == userId || u['id'] == userId,
              orElse: () => null,
            );
            return user != null ? (user['nom'] ?? user['username'] ?? '') : '';
          }

          return ListView.builder(
            itemCount: commandes.length,
            itemBuilder: (context, index) {
              final commande = commandes[index];
              final produits = commande['products'] as List<dynamic>? ?? [];
              final userId = commande['userId'];
              final userName = getUserName(userId);
              final userEmail = getUserEmail(userId);
              return Card(
                margin: EdgeInsets.all(12),
                child: ExpansionTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Commande de ${(userName?.isNotEmpty ?? false) ? userName : (commande['name'] ?? 'Utilisateur')}'),
                      if (userEmail?.isNotEmpty ?? false)
                        Text('Email : $userEmail', style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Téléphone : ${commande['phone'] ?? 'Non renseigné'}'),
                      Text('Date : ${commande['createdAt'] ?? ''}'),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      // supprimer la commande
                      deleteCommande(commande['_id'] ?? commande['id']);
                    },
                    icon: Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Supprimer la commande',
                  ),
                  children: [
                    Text('Produits commandés :', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...produits.map((produit) => ListTile(
                          title: Text((produit['name']?.toString().isNotEmpty == true)
                              ? produit['name']
                              : (produit['productId'] ?? 'Produit')),
                          subtitle: Text('Quantité: ${produit['quantity']}, Prix: ${produit['price']}'),
                        )),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}