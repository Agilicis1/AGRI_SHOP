import 'package:flutter/material.dart';
import 'package:front_agri_shop/homePage.dart';
import 'package:front_agri_shop/loginPage.dart';
import 'package:front_agri_shop/SplashScreen3.dart';
import 'package:front_agri_shop/page_indicators.dart';

class SpashScreen2 extends StatefulWidget {
  const SpashScreen2({Key? key}) : super(key: key);

  @override
  State<SpashScreen2> createState() => _SpashScreen2State();
}

class _SpashScreen2State extends State<SpashScreen2> {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
  }

  void _next() {
    setState(() {
      _opacity = 0.0;
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SpashScreen3()),
      );
    });
  }

  void _skip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 1000),
        child: SafeArea(
          child: Column(
            children: [
              // Header with Skip button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(), // 1/3 left empty
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(), // center empty
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _skip,
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Image between skip and title/description
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Image.asset(
                    'uploads/1750683153628.png',
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                ),
              ),
              // Title, description, and Next button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Bienvenue sur AgriShop',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Prenez simplement une photo de votre plante malade avec votre smartphone. Notre technologie intelligente analyse l\'image et identifie la maladie en quelques secondes.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(child: Container()),
                        Expanded(child: Container()),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _next,
                              child: Text(
                                'Next',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PageIndicators(currentStep: 1, totalSteps: 3),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}