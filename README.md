# AGRI SHOP

## Description

AGRI SHOP est une application mobile destinée aux agriculteurs, leur offrant une plateforme intuitive pour :
- Accéder à des produits phytosanitaires via un module e-commerce.
- Diagnostiquer les maladies des plantes grâce à une IA (photo ou upload d'image).
- Enrichir la base de données d'images pour l'IA via un module de contribution.
- Gérer les commandes, utilisateurs et produits via un back-office admin.

---

## Table des matières

1. [Technologies utilisées](#technologies-utilisées)
2. [Fonctionnalités](#fonctionnalités)
3. [Installation & Lancement](#installation--lancement)
4. [Architecture du projet](#architecture-du-projet)
5. [Structure des dossiers](#structure-des-dossiers)
6. [Pages principales](#pages-principales)
7. [Déploiement](#déploiement)
8. [À propos](#à-propos)
9. [Contribuer](#contribuer)
10. [Contact](#contact)

---

## Technologies utilisées

- **Frontend** : Flutter
- **Backend** : Node.js
- **Base de données** : MongoDB Atlas
- **IA** : OpenAI (modèle CNN en cours d'entraînement sur PlantVillage)

---

## Fonctionnalités

### Utilisateur
- Inscription/Connexion
- Navigation e-commerce (recherche, tri, catégories, panier, paiement)
- Diagnostic de maladies de plantes par IA (upload ou photo)
- Notifications de commandes

### Admin
- Gestion des produits (CRUD, images, descriptions)
- Gestion des utilisateurs (CRUD, rôles)
- Gestion des commandes (suivi, changement de statut)
- Visualisation et téléchargement des images uploadées pour l'IA

### IA
- Diagnostic instantané de maladies à partir d'images
- Suggestion de produits associés si disponibles

---

## Installation & Lancement

### Prérequis
- Node.js, npm
- Flutter
- Accès à MongoDB Atlas

### Variables d'environnement

Créer deux fichiers `.env` :

- À la racine du projet :
  ```
  MONGODB_URI=mongodb+srv://<user>:<password>@cluster0.0ahiujs.mongodb.net/
  ```
- Dans `backend-IA/` :
  ```
  OPENAI_API_KEY=sk-...
  ```

### Installation

#### Backend général
```bash
cd test-backend-Copie
npm install
node index.js
```

#### Backend IA
```bash
cd backend-IA
npm install
node indexIA.js
```

#### Frontend
```bash
cd front_AGRI_SHOP/front_agri_shop
flutter pub get
flutter build web
# Pour tester en local
flutter run
```

---

## Architecture du projet

- **Backend général** : gestion des utilisateurs, produits, commandes, notifications, images.
- **Backend IA** : diagnostic d'images via OpenAI.
- **Frontend** : application Flutter multi-plateforme (web, mobile, desktop).

---

## Structure des dossiers

```
test-backend-Copie/
│
├── backend-IA/           # Backend IA (Node.js, OpenAI)
├── front_AGRI_SHOP/      # Frontend Flutter
├── models/               # Schémas Mongoose (MongoDB)
├── uploads/              # Images uploadées
├── index.js              # Entrée backend général
├── orders.json           # Données de commandes (exemple)
├── users.json            # Données utilisateurs (exemple)
└── ...
```

---

## Pages principales

### Frontend (`/lib`)
- **about.dart** : Informations générales sur AGRI SHOP
- **homePage.dart** : Page d'accueil
- **loginPage.dart** : Connexion
- **registration.dart** : Inscription
- **admin/** : Interface d'administration (produits, utilisateurs, commandes, images)
- **commande/** : E-commerce (panier, paiement, notifications, détails produits)
- **IA/IA_page.dart** : Diagnostic de maladies par IA

### Backend
- **index.js** : Routes principales (produits, utilisateurs, commandes, notifications)
- **models/** : Schémas de la base de données

---

## Déploiement

- **Backend** : Render (identifiants dans la section privée)
- **Frontend** : Netlify
- **Backend IA** : render 

Variables d'environnement à configurer sur les plateformes de déploiement.

---

## À propos

AGRI SHOP vise à faciliter l'accès aux produits phytosanitaires et à l'expertise agronomique pour les agriculteurs, tout en enrichissant une base de données d'images pour l'amélioration continue de l'IA.

---

## Contribuer

Les contributions sont les bienvenues ! Merci de soumettre vos issues ou pull requests sur le dépôt GitHub.

---

## Contact
- GitHub : https://0000/0000/0000


# Projet Agri Shop 

## Description
Aplication mobile destinée au agriculteur , en leurs offrant une platforme mobilile intuitive dans laquelle ils pourrons accéder a des produits phytosanitaire via une un segment e_commerce , une autre partie leur permettant d'acceder a une IA leurs permettant de telecharger ou de prendre en photo une plante malade , cette derniere leurs propose un diagnostique instantanée pour statuer sur la maladie de la plante(une description détailler de la maladie et une proposition du produit si cette derniere est disponible dans la  base de donnée). Un module (loading Image) pour telecharger des images de plantes et leurs descriptions pour les enregistrer dans la bdd.L'application mobile posséde aussi un back-office. 

## Technologie utilisée

### frontend : flutter 
### backend : node.js
### base de donnée : mongo_db_atlass 
### IA : open AI (nous somme entrain d'entrainner notre propre model d'IA(un CNN entrainner sur les données de plant-Village pour la détection des maladies des plantes))

# Fonctionalités 
### Register 
#### l'utilisateur peut creer un compte ou se connecter dans notre base de donnée)
### E_Commerce
#### un module e_commerce de vente de produit phytosanitaire est mis a disposition des utilisateurs , leurs permettant de pouvoir rechercher des produit , les ajouter au panier , procéder au paiement via different mode de paiement (wave , orange Money , ou carte Bancaire) 
### IA 
#### une IA intuitive basée sur OpenAI , permettant au utilisateur de pouvoir (prendre en photo ou selectionner une image de plante malade et de leurs proposées un diagunostique adéquat pour la maladie défie ,leurs proposer le produit si il est disponible dans la base de donnée)

### interface Admin 
### 1-module produit 
#### permettant au admin de creer un produit avec une image , le nom , la description du produit  etc 
### 2-module utilisateur
#### la capicitée de creer, de voir ou de modifier les informations d'un  ou des utilisateurs 
### 3-module commande 
####  la capacités d'accéder aux commandes des utilisateurs ( prévue dans les dev de pouvoir changer le statut d'une commande)
### 4-module reloadingImage
#### afficher les images uploader par les utilisateurs (de permettre leurs telechargements ) pour enrichire la base de donnée RMG pour l'entrainement du modéle d'IA
### Les roles (useurs ou admin ) sont attribuer par le developpeur pour l'instant depuis la base de données (mongo_db_atlass)

# quick Start 
## les fichier .env sont actuellement exclu , ( le projet est ectuellement deployer avec render et netlify) donc nous n'en avons pas reelment besoin sauf pour repasser en local. 
## dans le cadre du repassage en local il faudrais faire 2 fichier env , le premien dans juste l'entrée du fichier *cd TEST-BACKEND-COPIE* , les éléments a mettre dans se fichier env ** , un autre fiichier .env  seras creer dans la partie backend IA , en y accédant par *cd backend-IA* ,et y mettre la clef Api d'openAI** 
## render pour le deploiement du backend avec les id render suivant " email : mohamed.guisse@agilicis.com " , "password : Pilote2122"
## le front est deployer sur netlify , avec les memes identifiant de connexion , 
## le backend-IA est aussi deployer sur netlify avec la variable d'environnement suivante **  il s'agit de la clef APi d'openAI  , concernant la connexion a la base de données mongo_DB_atlas , voici si prés l'url de connexion a la base de donnée : **

### cloner le projet 
### git clone https://000.com/000000/00000.git 
## lancement du front 
### cd front_AGRI_SHOP
### cd front_AGRI_SHOP 
### bien ecrire le chemain 2 fois 
### flutter pub get 
### flutter build web ( pour recupérer le fichier web de l'application et pouvoir permettre le deploiement de la partie front de ###l'applcation (il s'agit du fichier a selectionner lors du déploiement de l'application sur netlify))
### flutter run ( optionnel , car nous deployons directement le front donc nous n'avont pas forcément besoin de le lancer en local ( sauf pour un usage de test avant deploiement))
## pour lancer le backend 
### npm install 
### node in index.js 
## pour lancer le backend de l'IA
### cd backend-IA 
### npm install ( pour telecharger les dépendances)
### node indexIA.js (pour lancer le backend de la partie IA )

# Architechture de L'application 
## Architechture Général (backend GENERAL)
### cd TEST-BACKEND-COPIE 

#models/
#├── /meddlewear
    └── verificatioToken
    └── cart.model.js
    └── loading_image.js
    └── notification.model.js 
    └── order.model.js
    └── product.model.js
    └── user.model.js
    └── index.js
# les models
## sont les schemas de configuration de la base de données mongo_db_atlas
## On y retrouve les spécifications de chaque table de la base de données 
## si nous prennons exemple sur la table user.model : 
## nous avons les champs : nom , telephone , email , password , role  qui constitue le schemas de la base de données des   utilisateurs creer vias mongoàse.shema ainsi de suite pour toutes les autres model de la base de données 
# Index.js 
## ils s'agit de la  page principale de l'application , on y retrouves les routes (tous les endpoints de l'application) et leurs implémentations  
## nous pouvons prendre exemple sur le endpoint suivant */api/notifications*  et la requette https suivant ( get) . cette route nous permet d'acceder directement a la base de donnée de l'application et de recupérer les notifications( la liste des notification ), ainsi de suite pour chaque endpoint et ces requettes https . 

## Architechture Général (front de l'application)
## accés via  *cd front_AGRI_SHOP* 
## *cd front_AGRI_SHOP*
#├── /lib 
    └── admin
         └── adminHome.dart
         └── gestionCommande.dart
         └── gestionDesClients.dart
         └── gestionProduit.dart 
         └── reloadingImg.dart 

#adminHome.dart 
## c'est la page principale de l'interface admin, elle regroupe principalement 4 cubewithlogo ( 4 cube cliquable remenant chacune a une page differente dans l'interface de l'application) elle permet ainsi au admin un primier visuelle dans l'application et leurs permet ainsi de naviger vers les autres pages. 

#gestionDesClients.dart 
## une page permettant un crud des utilisateur ( en effet elle permet de creer , de modifier , de supprimer des utilisateur directement depuis l'interface admin ) ainsi qu'afficher la liste des utilisateur et de leurs roles. 

#gesttionDesProduits.dart
## Cette interface permet au admins de pouvoir creer des produits vias l'interface  avec une ( photos , un nom , une description , et une image du produit) il faut aussi sa voir que toutes les image de cette applications sont sauvegarder de maniere suivante :
## 1 - le chemain d'accés de l'image est enrigistrer dans la base de données mongos DB atlas 
##  les images en temps que tel sont enrigistrer dans un fichier upload de l'application 
## donc ces dernier sont recupérer lors de l'affichage de l'image dans la plateforme en passant par l'url du endpoint du depot 

# reloadingImg.dart 
## cette page  permet de visualiser ( et par la suite telecharger les images , qu'ont fournie l'application ) pour enrichire la base de données  et permettre un meilleur entrainement du model , les images sont directement recupérer de puis la base de donnés , et du fichier upload .
## sur cette page nous pouvouns appercevoir la liste des (images , leurs categories et la description associer a cette derniere)

#Switch sur la partie commande de l'application
# Architechture General de la partie Useur

    └── commande
         └── cartPage.dart 
         └── e_commerce.dart  
         └── notification_page.dart 
         └── paiementPage.dart 
         └── product_detail_page.dart 
         └── productModel.dart 

## architechture détailler des classes  concernée 

# productModel.dart
## s'est la classe qui rassamble les fonctionnalitées  des produits , de meme que la structure du composant , c'est se dernier qui seras appeler lors de creation d'un produit ou de la mise d'un produit  dans la page e_commerce , pour permettre au utilisateur de pouvoir ajouter des produits. 
#CartPage.dart 
## il s'agit de la page de panier , elle dispose d'un listvieuw buildeur pour afficher les produits ajouter au panier par l'utilisateur dans  sa session . 

#e_commerce 

## page de chopping des utilisateurs , leur  permetant de voir les produits disponibles dans la base de données de pouvoir ajouter au panier les produit de leurs choix ( ces derniers sont recupérer depuis la base de donnée et afficher grace a productModel) avec le listViewBuilder de la page e_commere . Plusieurs fonctionalitées sont disponible  , comme la recherche de produit , le trie par prie croissant , la catégorisation des produits ( ex: insecticide , nemacide , fongicide)

#paiementPage.dart 

## il s'agit de la page de paiemend de l'application ofrant un boutton permettant de choisir son moyen de paiment ( wave, orange money , carte Bancaire , ou espece ) , ces information permettant de valider une commande et permettre au admin de procéder au suivis de la commande.

# product_detail_page.dart

## ils s'agit d'une page ( prévue pour les  développements future ) , elle permettras de fournir une description détailer du produit concerner , ( il s'agit d'une page de presentation des poduits lorsequ'un utilsateur clique sur le composant produuit dans la page e_commerce ).

# notification_page ! 
## une page armée d'un l'istener( et un model de notification ) qui afficheras les informations d'une commande ( lorsequ'une commande est creer )  . 

# 
     └── IA 
         └── IA_page.dart 

# IA_page.dart 

## une page qui affiche un boutton upload pour permettre au useur de telecharger une image ou de prendre une photo de leur plate , cette image est ensuite afficher puis envoyer au backend pour que se dernier envoie l'image via api a OpenAI pour que se se dernier retourne une description detailler  la maladie et ce texte est afficher sur la plateform . Si le produit concerner est disponible dans le base de donnés , l'application affiche automatiquement un boutton permettant d'ajouter le produit au pannier (pas encore de regex mais plutaut une fonction contains ( pour voir si le text contient un productname , si oui un bouton ajouter au panier s'affiche) cette fonctionalitée est a revoir car elle n'est pas optimal , meme si le nom_produit  s'affiche juste sur un texte et que le produit match avec un product_name , la platform permet au utilisateur d'ajouter le  produit au panier).


# Structure Générale des page d'entrée ( premiere page de l'application )

    └──── about.dart 
    └──── gestionsdesprofiles 
    └──── homePage.dart 
    └──── loginPage.dart 
    └──── main.dart 
    └──── page_indicators.dart 
    └──── registration.dart 
    └──── Splash_Screen.dart 
    └──── Splash_Screen2.dart 
    └──── Splash_Screen3.dart 

# Description des pages principales

- **about.dart** : Page d'informations générales sur AGRI SHOP, sa mission, ses fonctionnalités et l'équipe.
- **gestionsdesprofiles.dart** : Permet à l'utilisateur de consulter et modifier son profil, gérer ses informations personnelles et ses paramètres.
- **homePage.dart** : Page d'accueil de l'application, point d'entrée principal avec accès rapide aux différentes fonctionnalités (e-commerce, IA, notifications, etc.).
- **loginPage.dart** : Interface de connexion pour les utilisateurs existants, avec gestion des erreurs et redirection vers l'inscription si besoin.
- **main.dart** : Point d'entrée principal de l'application Flutter, gère la navigation globale et l'initialisation des services.
- **page_indicators.dart** : Composant graphique pour afficher la progression dans les pages d'onboarding ou de navigation multi-étapes.
- **registration.dart** : Page d'inscription pour les nouveaux utilisateurs, collecte des informations nécessaires à la création d'un compte.
- **Splash_Screen.dart**, **Splash_Screen2.dart**, **Splash_Screen3.dart** : Écrans d'introduction affichés au lancement de l'application, servant à présenter l'application, son logo, et à effectuer un chargement initial ou une animation de bienvenue.























