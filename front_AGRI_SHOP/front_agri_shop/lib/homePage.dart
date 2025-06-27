import 'package:flutter/material.dart';
import 'IA/IA_page.dart';
import 'about.dart';
import 'commande/notification_page.dart';
import 'loginPage.dart';
import 'commande/e-commerce.dart';
import '../commande/cartPage.dart';import 'package:flutter/material.dart';
import '../commande/productModel.dart';
import '../services/loadingImage.dart';
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
            icon: Icon(Icons.logout),
          ),
          IconButton(
            onPressed:(){
              Navigator.push(context,MaterialPageRoute(builder: (context) => About()) );
            },
            icon: Icon(Icons.info),
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
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
                label: 'E-commerce',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>ECommerce()));
                },
              ),
              CubeWithLogo(
                color: Colors.green,
                icon: Icons.smart_toy,
                label: 'IA',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => IA_page()));
                },
              ),
              CubeWithLogo(
                color: Colors.green,
                icon: Icons.eco,
                label: 'Images',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoadingImage()));
                },
              ),
              CubeWithLogo(
                color: Colors.green,
                icon: Icons.notifications,
                label: 'Notifications',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage()));
                },
              ),
            ],
          ),
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

class ClientHomePage extends StatelessWidget {
  final String userName;
  const ClientHomePage({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenue $userName'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
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
                label: 'E-commerce',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ECommerce()));
                },
              ),
              CubeWithLogo(
                color: Colors.green,
                icon: Icons.smart_toy,
                label: 'IA',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => IA_page()));
                },
              ),
              CubeWithLogo(
                color: Colors.green,
                icon: Icons.notifications,
                label: 'Notifications',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationPage()));
                },
              ),
              CubeWithLogo(
                color: Colors.green,
                icon: Icons.eco,
                label: 'Images',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoadingImage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
