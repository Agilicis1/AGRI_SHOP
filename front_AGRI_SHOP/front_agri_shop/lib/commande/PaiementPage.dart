import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:front_agri_shop/homePage.dart';
import 'package:front_agri_shop/commande/cartPage.dart';
import 'package:front_agri_shop/commande/e-commerce.dart';
import 'package:front_agri_shop/commande/productModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:front_agri_shop/commande/notificationModel.dart';
import 'package:front_agri_shop/commande/notification_page.dart';


class PaiementPage extends StatefulWidget {
  @override
  _PaiementPageState createState() => _PaiementPageState();
}

class _PaiementPageState extends State<PaiementPage> {
  bool isLoading = false;
  String phone = '';
  String cardNumber = '';
  String paymentMethod = '';
  String modepayement = '';
  String? userID;
  String name = 'NomUtilisateur';

  @override
  void initState() {
    super.initState();
    loadUserId();
  }

  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getString('userId');
    });
  }

  Future<void> passerCommande() async {
    if (userID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Utilisateur non connecté')),
      );
      return;
    }
    setState(() => isLoading = true);
    final url = Uri.parse('http://localhost:3000/api/orders');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userID,
          'phone': phone,
          'name': name,
          'paymentMethod': paymentMethod,
          'products': Cart.items.map((item) => item.toJsonWithPayment(phone, modepayement)).toList(),
        }),
      );
      setState(() => isLoading = false);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Commande réussie !'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // ajouter la notification dans la page notification
        NotificationService.addNotification(NotificationModel(
          id: '1',
          title: 'Commande réussie',
          message: 'Votre commande a été réussie',
          products: Cart.items.map((item) => item.toJsonWithPayment(phone, modepayement)).toList(),
          date: DateTime.now().toString(),
          status: 'success',
        ));
        // envoyer la notification au backend 
        final notifResponse = await http.post(
          Uri.parse('http://localhost:3000/api/notifications'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'userId': userID,
            'products': Cart.items.map((item) => item.toJsonWithPayment(phone, modepayement)).toList(),
            'date': DateTime.now().toString(),
            'status': 'success',
          }),
        );
        if (notifResponse.statusCode == 200 || notifResponse.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Notification envoyée avec succès'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        } else if (notifResponse.statusCode == 400) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de l\'envoi de la notification'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        } else if (notifResponse.statusCode == 500) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur serveur lors de l\'envoi de la notification'),
            ),
          );
        }

        await Future.delayed(Duration(seconds: 2));
        Cart.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de validation des données'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      } else if (response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur serveur'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        setState(() => isLoading = false);
        print('Erreur: ${response.statusCode} - ${response.body}');
        await Future.delayed(Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ECommerce()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la commande'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur réseau'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void showPhoneDialog(String method) {
    if (method.toLowerCase().contains('wave')) {
      paymentMethod = 'wave';
      modepayement = 'wave';
    } else if (method.toLowerCase().contains('orange')) {
      paymentMethod = 'orange Money';
      modepayement = 'orange Money';
    } else {
      paymentMethod = 'espece';
      modepayement = 'espece';
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Paiement par $method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Veuillez entrer votre numéro de téléphone'),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Numéro de téléphone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                  prefixIconColor: Colors.green,
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  phone = value;
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await passerCommande();
                },
                child: Text('Valider'),
              ),
            ],
          ),
        );
      },
    );
  }

  void showCardDialog() {
    paymentMethod = 'espece';
    modepayement = 'espece';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Paiement par Carte bancaire'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Veuillez entrer les informations de votre carte'),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Numéro de carte',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.credit_card),
                  prefixIconColor: Colors.green,
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  cardNumber = value;
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await passerCommande();
                },
                child: Text('Valider'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paiement'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Choisis ta méthode de paiement'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Méthode de paiement'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: Icon(Icons.account_balance_wallet, color: Colors.blue),
                                  title: Text('Wave'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    showPhoneDialog('Wave');
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.credit_card, color: Colors.purple),
                                  title: Text('Carte bancaire'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    showCardDialog();
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.phone_android, color: Colors.orange),
                                  title: Text('Orange Money'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    showPhoneDialog('Orange Money');
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Text('Choisir une méthode de paiement'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
