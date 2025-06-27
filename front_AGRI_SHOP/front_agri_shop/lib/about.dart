import 'package:flutter/material.dart';
import 'homePage.dart';

class About extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('A propos'),
                backgroundColor: Colors.green,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                        Navigator.pop(context);
                    },
                ),
            ),
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Center(
                            child: Icon(
                                Icons.info_outline,
                                size: 80,
                                color: Colors.green,
                            ),
                        ),
                        SizedBox(height: 16),
                        Center(
                            child: Text(
                                'À propos de AgriShop',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[800],
                                ),
                            ),
                        ),
                        SizedBox(height: 24),
                        Text(
                            'AgriShop est une application dédiée à la vente et à l’achat de produits agricoles. '
                            'Notre mission est de faciliter la connexion entre agriculteurs et leurs plantes'
                            'en offrant une plateforme simple, rapide et sécurisée.',
                            style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 24),
                        Text(
                            'Version : 1.0.0',
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 8),
                        Text(
                            'Développé par : AGILICIS',
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        Spacer(),
                        Center(
                            child: Text(
                                '© 2025 AgriShop. Tous droits réservés.',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                        ),
                    ],
                ),
            )
        );
    }
}
