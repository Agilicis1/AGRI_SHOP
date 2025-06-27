import 'package:flutter/material.dart';

/// Composant des 3 points de navigation pour indiquer la progression dans les pages
class PageIndicators extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const PageIndicators({
    Key? key,
    this.currentStep = 2, // Étape actuelle (0-indexé)
    this.totalSteps = 3,   // Nombre total d'étapes
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Largeur responsive pour les petits écrans
    double getContainerWidth() {
      if (screenWidth <= 640) return 60.0;
      return 80.0;
    }

    return SizedBox(
      width: getContainerWidth(),
      height: 10.0,
      child: Stack(
        children: [
          // Premier indicateur
          Positioned(
            left: 0.0,
            top: 0.0,
            child: Container(
              width: 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: currentStep >= 0
                  ? const Color(0xFF22C51C) // Vert actif
                  : const Color(0xFF17223B).withOpacity(0.20), // Gris inactif
              ),
            ),
          ),

          // Deuxième indicateur
          Positioned(
            left: 20.0,
            top: 0.0,
            child: Container(
              width: 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: currentStep >= 1
                  ? const Color(0xFF22C51C) // Vert actif
                  : const Color(0xFF17223B).withOpacity(0.20), // Gris inactif
              ),
            ),
          ),

          // Troisième indicateur (allongé quand actif)
          Positioned(
            left: 40.0,
            top: currentStep >= 2 ? 1.0 : 0.0, // Position légèrement décalée quand actif
            child: Container(
              width: currentStep >= 2 ? 40.0 : 10.0, // Largeur étendue quand actif
              height: currentStep >= 2 ? 8.0 : 10.0, // Hauteur réduite quand actif
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: currentStep >= 2
                  ? const Color(0xFF22C51C) // Vert actif
                  : const Color(0xFF17223B).withOpacity(0.20), // Gris inactif
              ),
            ),
          ),
        ],
      ),
    );
  }
} 