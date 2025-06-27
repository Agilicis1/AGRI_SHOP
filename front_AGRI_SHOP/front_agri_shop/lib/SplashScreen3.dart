import 'package:flutter/material.dart';
import 'package:front_agri_shop/homePage.dart';
import 'package:front_agri_shop/loginPage.dart';
import 'package:front_agri_shop/SpashScreen2.dart';
import 'package:front_agri_shop/page_indicators.dart';

class SpashScreen3 extends StatefulWidget {
  const SpashScreen3({Key? key}) : super(key: key);

  @override
  State<SpashScreen3> createState() => _SpashScreen3State();
}

class _SpashScreen3State extends State<SpashScreen3> {
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
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  void _skip() {
    setState(() {
      _opacity = 0.0;
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 800),
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
                    'uploads/1750687925865.png',
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
                      'E_commerce agricole',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                            'Achetez des produits agricoles en ligne.Sans vous deplacer.En payant par Wave, Orange Money ou par carte Bancaire',
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
                              onPressed: _skip,
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
              PageIndicators(currentStep: 2, totalSteps: 3),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}