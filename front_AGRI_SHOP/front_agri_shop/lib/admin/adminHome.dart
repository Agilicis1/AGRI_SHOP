import 'package:flutter/material.dart';
import 'gestionProduit.dart';
import 'gestionDesClients.dart';
import 'gestionCommande.dart';
import 'reLoadingImg.dart'; 
import '../loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AdminHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('userId');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false,
              );
            },
          ),
          ],
      ),
      body: SingleChildScrollView(
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          children: [
            CubeWithLogo(
              color: Colors.green,
              icon: Icons.store,
              label: 'Gestion des produits',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => GestionDesProduits()));
              },
            ),
            CubeWithLogo(
              color: Colors.green,
              icon: Icons.person,
              label: 'Gestion des clients',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => GestionDesClients()));
              },
            ),
            CubeWithLogo(
              color: Colors.green,
              icon: Icons.card_travel,
              label: 'Gestion des commandes',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => GestionDesCommandes()));
              },
            ),
            CubeWithLogo(
              color: Colors.green,
              icon: Icons.image,
              label: 'Gestion des images',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ReLoadingImg()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CubeWithLogo extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const CubeWithLogo({
    Key? key,
    required this.color,
    required this.icon,
    required this.label,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 50,
                ),
                SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

