import 'package:flutter/material.dart';
import 'package:front_agri_shop/loginPage.dart';
import 'package:front_agri_shop/homePage.dart';
import 'package:flutter/widgets.dart';
import 'package:front_agri_shop/SpashScreen2.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    Future.delayed( const Duration(seconds: 5), () {
      setState(() {
        _opacity =0.0;
      });
      Future.delayed(const Duration(milliseconds: 1000), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SpashScreen2()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 1000),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SpashScreen2()));
            },
            child: Container(
              decoration: BoxDecoration(
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Transform.rotate(
                    angle: 0.05,
                    child: Text(
                      'Agri',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        height: 1,
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: -0.05,
                    child: Text(
                      'Shop',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}