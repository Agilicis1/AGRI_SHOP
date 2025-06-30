import 'package:flutter/material.dart';
import 'adminHome.dart';
import 'gestionCommande.dart';
import 'gestionProduit.dart';
import 'reLoadingImg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class GestionDesClients extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des clients'),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                'Bienvenue sur la page de gestion des clients',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              SizedBox(height: 32),
              CreerUtilisateurWidget(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class CreerUtilisateurWidget extends StatefulWidget {
  @override
  _CreerUtilisateurWidgetState createState() => _CreerUtilisateurWidgetState();
}

class _CreerUtilisateurWidgetState extends State<CreerUtilisateurWidget> {
  final _formKey = GlobalKey<FormState>();
  String nom = '', email = '', motDePasse = '', telephone = '';
  bool isLoading = false;
  bool showPassword = false;
  List<dynamic> utilisateurs = [];
  Timer? _timer;
  bool showUsersList = false;
  TextEditingController telephoneController = TextEditingController();


  @override
  void initState() {
    super.initState();
    getUtilisateurs();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      getUtilisateurs();
    });
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> getUtilisateurs({bool showSnackbar = false}) async {
    final url = Uri.parse('https://agri-shop-5b8y.onrender.com/api/users');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Réponse utilisateurs: $data');
      if (data is List) {
        setState(() => utilisateurs = data);
      } else if (data is Map && data['users'] is List) {
        setState(() => utilisateurs = data['users']);
      } else {
        setState(() => utilisateurs = []);
      }
    } else {
      if (showSnackbar) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur HTTP: ${response.statusCode}')),
        );
      }
    }
  }

  Future<void> supprimerUtilisateur(String id) async {
    final url = Uri.parse('https://agri-shop-5b8y.onrender.com/api/users/$id');
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      await getUtilisateurs();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Utilisateur supprimé !'), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> modifierUtilisateur(String id, String nom, String email, String motDePasse, String telephone) async {
    final url = Uri.parse('https://agri-shop-5b8y.onrender.com/api/users/$id');
    final response = await http.put(url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nom': nom,
        'email': email,
        'password': motDePasse,
        'telephone': telephone,
      }),
    );
    if (response.statusCode == 200) {
      await getUtilisateurs();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Utilisateur modifié !'), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la modification'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> creerUtilisateur() async {
    setState(() => isLoading = true);
    final url = Uri.parse('https://agri-shop-5b8y.onrender.com/api/auth/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nom': nom,
          'email': email,
          'password': motDePasse,
          'telephone': telephone,
        }),
      );
      setState(() => isLoading = false);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Utilisateur créé !'), backgroundColor: Colors.green),
        );
        _formKey.currentState?.reset();
        await getUtilisateurs();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la création'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur réseau ou serveur'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Créer un nouvel utilisateur',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nom'),
                    validator: (value) => value == null || value.isEmpty ? 'Champ obligatoire' : null,
                    onSaved: (value) => nom = value!.trim(),
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email (optionnel)'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return null; 
                      }
                      return value.contains('@') ? null : 'Email invalide';
                    },
                    onSaved: (value) => email = value?.trim() ?? '',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: telephoneController,
                    decoration: InputDecoration(labelText: 'Téléphone'),
                    keyboardType: TextInputType.phone,
                    onSaved: (value) => telephone = value!.trim(),
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      suffixIcon: IconButton(
                        icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => showPassword = !showPassword),
                      ),
                    ),
                    obscureText: !showPassword,
                    validator: (value) =>
                        value != null && value.length >= 6 ? null : '6 caractères min.',
                    onSaved: (value) => motDePasse = value!,
                  ),
                  SizedBox(height: 20),
                  isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          child: Text('Créer utilisateur'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              await creerUtilisateur();
                            }
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        ElevatedButton(
          onPressed: () async {
            await getUtilisateurs(showSnackbar: true);
            setState(() {
              showUsersList = !showUsersList;
            });
          },
          child: Text(showUsersList ? 'Cacher la liste des utilisateurs' : 'Afficher la liste des utilisateurs'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
        SizedBox(height: 24),
        if (showUsersList) ...[
          Text('Liste des utilisateurs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 8),
          utilisateurs.isEmpty
              ? Text('Aucun utilisateur trouvé.')
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: utilisateurs.length,
                  itemBuilder: (context, index) => _utilisateurItem(utilisateurs[index]),
                ),
        ],
      ],
    );
  }

  Widget _utilisateurItem(dynamic utilisateur) {
    return ListTile(
      title: Text(utilisateur['nom'] ?? ''),
      subtitle: Text(
        '${utilisateur['email'] ?? ''}\nRôle: ${utilisateur['role'] ?? 'Non défini'}\nTéléphone: ${utilisateur['telephone'] ?? 'Non défini'}',
        style: TextStyle(fontSize: 14),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              // Afficher un dialog pour modifier l'utilisateur
              String newNom = utilisateur['nom'] ?? '';
              String newEmail = utilisateur['email'] ?? '';
              String newPassword = '';
              String newTelephone = '';
              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Modifier utilisateur'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          initialValue: newNom,
                          decoration: InputDecoration(labelText: 'Nom'),
                          onChanged: (value) => newNom = value,
                        ),
                        TextFormField(
                          initialValue: newEmail,
                          decoration: InputDecoration(labelText: 'Email'),
                          onChanged: (value) => newEmail = value,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Nouveau mot de passe'),
                          onChanged: (value) => newPassword = value,
                          obscureText: true,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Téléphone'),
                          onChanged: (value) => newTelephone = value,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: Text('Annuler'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      ElevatedButton(
                        child: Text('Enregistrer'),
                        onPressed: () async {
                          Navigator.pop(context);
                          await modifierUtilisateur(
                            utilisateur['_id'],
                            newNom,
                            newEmail,
                            newPassword.isNotEmpty ? newPassword : utilisateur['password'] ?? '',
                            newTelephone,
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            style: IconButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await supprimerUtilisateur(utilisateur['_id']);
            },
          ),
        ],
      ),
    );
  }
}