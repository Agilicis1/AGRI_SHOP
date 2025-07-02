const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
require('dotenv').config();
console.log('OPENAI_API_KEY:', process.env.OPENAI_API_KEY);
const cors = require('cors');
const app = express();
app.use(cors());
app.use(bodyParser.json());
// Connexion à MongoDB
mongoose.connect(process.env.MONGODB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
}); 
const User = require('./models/user.model');
const Order = require('./models/order.model');
const Product = require('./models/product.model');
const Notification = require('./models/notification.model');
const Cart = require('./models/cart.model');
const multer = require('multer');
const path = require('path');
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname));
  }
});
const upload = multer({ storage: storage });
const Loading_image = require('./models/loading_image');

// Endpoint register 
app.post('/api/auth/register', async (req, res) => {
  try {
    const user = new User(req.body); 
    await user.save();
    res.status(201).json({ message: 'Utilisateur enregistré avec succès !', user });
  } catch (err) {
    console.error('Erreur lors de l\'enregistrement:', err);
    res.status(500).json({ error: 'Erreur lors de l\'enregistrement' });
  }
});
// creer un notification
app.post('/api/notifications', async (req, res) => {
  try{
    const notification = new Notification(req.body)
    await notification.save(); 
    res.status(201).json({message:'notification creer avec succés'})
  }catch(err){
    res.status(500).json({error:'Erreur lors de la creation de la notification'})
  }
});
// suprimer une notification 
app.delete('/api/notifications/:id', async (req, res) => {
  try {
    const { id } = req.params; 
    const notification = await Notification.findByIdAndDelete(id); 
    if (!notification) {
      return res.status(404).json({ error: 'notification non trouvée' });
    }
    res.status(200).json({ message: 'notification supprimée avec succès', notification });
  } catch (err) {
    res.status(500).json({ message: 'erreur lors de la suppression de la notification' });
  }
});
// Récupérer la liste des notifications
app.get('/api/notifications', async (req, res) => {
  try {
    const notifications = await Notification.find(); 
    res.status(200).json(notifications);
  } catch (err) {
    res.status(500).json({ error: 'Erreur lors de la récupération de la liste des notifications ' });
  }
});

// Endpoint de connexion
app.post('/api/auth/login', async (req, res) => {
  const { email, password, telephone } = req.body;
  let user = null;
  if (email && email.trim() !== '') {
    user = await User.findOne({ email });
  } else if (telephone && telephone.trim() !== '') {
    user = await User.findOne({ telephone });
  }

  if (!user) {
    return res.status(401).json({ message: 'Utilisateur non trouvé' });
  }

  const isMatch = user.password === password;
  if (!isMatch) {
    return res.status(401).json({ message: 'Mot de passe incorrect' });
  }

  // Réponse avec les infos utilisateur
  res.json({
    user: {
      _id: user._id,
      nom: user.nom,
      email: user.email,
      telephone: user.telephone,
      role: user.role,
    }
  });
});

// Créer une commande
app.post('/api/orders', async (req, res) => {
  try {
    // Pour chaque produit, s'assurer que le champ 'name' est bien présent
    const productsWithName = await Promise.all((req.body.products || []).map(async (prod) => {
      if (!prod.name && prod.productId) {
        // Récupérer le nom du produit depuis la base si absent
        const productDoc = await Product.findById(prod.productId);
        return {
          ...prod,
          name: productDoc ? productDoc.name : '',
        };
      }
      return prod;
    }));
    const order = new Order({
      ...req.body,
      products: productsWithName,
    });
    await order.save();
    res.status(201).json({ message: 'Commande enregistrée avec succès' });
  } catch (err) {
    console.error('Erreur lors de l\'enregistrement de la commande:', err);
    res.status(500).json({ error: 'Erreur lors de l\'enregistrement de la commande', details: err.message, stack: err.stack });
  }
});

// Récupérer la liste des users 
app.get('/api/users', async (req, res) => {
  try {
    const users = await User.find();
    res.status(200).json(users);
  } catch (err) {
    res.status(500).json({ error: 'Erreur lors de la récupération des utilisateurs' });
  }
});

// Récupérer la liste des commandes d'un utilisateur
app.get('/api/users/:id/orders', async (req, res) => {
  try {
    const { id } = req.params; 
    const orders = await Order.find({ userId: id });
    res.status(200).json(orders);
  } catch (err) {
    res.status(500).json({ error: 'erreur lors de la récupération de la liste des commandes' });
  }
});

// Supprimer un utilisateur (par un admin)
app.delete('/api/users/:id', async (req, res) => {
  try {
    const { id } = req.params;
    await User.findByIdAndDelete(id);
    res.status(200).json({ message: 'Utilisateur supprimé avec succès' });
  } catch (err) {
    res.status(500).json({ error: 'Erreur lors de la suppression de l\'utilisateur' });
  }
});

// Récupérer la liste des commandes
app.get('/api/orders', async (req, res) => {
  try {
    const orders = await Order.find();
    res.status(200).json(orders);
  } catch (err) {
    res.status(500).json({ error: 'Erreur lors de la récupération des commandes' });
  }
});

// Supprimer une commande (par un admin)
app.delete('/api/orders/:id', async (req, res) => {
  try {
    const order = await Order.findByIdAndDelete(req.params.id);
    if (!order) {
      return res.status(404).json({ error: 'Commande non trouvée' });
    }
    res.json({ message: 'Commande supprimée avec succès' });
  } catch (err) {
    res.status(500).json({ error: 'Erreur lors de la suppression de la commande' });
  }
});
// changer le statut d'une commande 
app.put('/api/orders/:id', async(req,res)=>{
  try{
    const{id}= req.params; 
    const order = await Order.findByIdAndUpdate(id, req.body, {new: true})
    if(!order){
      return res.status(404).json({error: 'commande non trouvée'})
    }
    res.status(200).json({message: 'statut de la commande changé avec succès', order})
  }catch(err){
    res.status(500).json({error: 'erreur lors du changement de statut de la commande'})
  }
})
// Créer un produit
app.post('/api/products', upload.single('image'), async (req, res) => {
  try {
    console.log('req.body', req.body);
    const { name, price, description, quantity, categorie } = req.body;
    let imageUrl = '';
    if (req.file) {
      imageUrl = `uploads/${req.file.filename}`;
    }
    const product = new Product({
      name,
      price,
      description,
      image: imageUrl,
      quantity, 
      categorie
    });
    await product.save();
    res.status(201).json({ message: 'Produit enregistré avec succès', product });
  } catch (err) {
    console.error('Erreur lors de la création du produit:', err);
    if (err.stack) console.error(err.stack);
    res.status(500).json({ error: "Erreur lors de l'enregistrement du produit", details: err.message });
  }
});
// supprimer un produit 
app.delete('/api/products/:id', async (req, res) => {
  try{
    const {id} = req.params; 
    console.log('Suppression du produit avec id:', id);
    const product = await Product.findByIdAndDelete(id)
    if(!product){
      return res.status(404).json({error: 'produit non trouvé'})
    }
    res.status(200).json({message: 'produit supprimé avec succès', product})
  }catch(err){
    console.error(err);
    res.status(500).json({error: 'erreur lors de la suppression du produit'})
  }
})

// Récupérer la liste des produits
app.get('/api/products', async (req, res) => {
  try {
    const products = await Product.find();
    res.status(200).json(products);
  } catch (err) {
    res.status(500).json({ error: 'Erreur lors de la récupération des produits' });
  }
});
// modifier un produit 
app.put('/api/products/:id', async (req, res) => {
  try{
    const{id}= req.params; 
    const product = await Product.findByIdAndUpdate(id, req.body, {new: true})
    if(!product){
      return res.status(404).json({error: 'produit non trouvé'})
    }
    res.status(200).json({message: 'produit modifié avec succès', product})
  }catch(err){
    res.status(500).json({error: 'erreur lors de la modification du produit'})
  }
})

// Récupérer le panier de l'utilisateur
app.get('/api/cart/:userId', async (req, res) => {
  try {
    const cart = await Cart.findOne({ userId: req.params.userId }).populate('items.productId');
    res.status(200).json(cart || { userId: req.params.userId, items: [] });
  } catch (err) {
    res.status(500).json({ error: 'Erreur lors de la récupération du panier' });
  }
});

// Ajouter un produit au panier
app.post('/api/cart/:userId/add', async (req, res) => {
  const { productId, quantity } = req.body;
  try {
    let cart = await Cart.findOne({ userId: req.params.userId });
    if (!cart) {
      cart = new Cart({ userId: req.params.userId, items: [] });
    }
    const itemIndex = cart.items.findIndex(item => item.productId.equals(productId));
    if (itemIndex > -1) {
      cart.items[itemIndex].quantity += quantity;
    } else {
      cart.items.push({ productId, quantity });
    }
    await cart.save();
    res.status(200).json(cart);
  } catch (err) {
    res.status(500).json({ error: "Erreur lors de l'ajout au panier" });
  }
});

// Supprimer un produit du panier
app.post('/api/cart/:userId/remove', async (req, res) => {
  const { productId } = req.body;
  try {
    let cart = await Cart.findOne({ userId: req.params.userId });
    if (!cart) return res.status(404).json({ error: 'Panier non trouvé' });
    cart.items = cart.items.filter(item => !item.productId.equals(productId));
    await cart.save();
    res.status(200).json(cart);
  } catch (err) {
    res.status(500).json({ error: 'Erreur lors de la suppression du produit du panier' });
  }
});

// Vider le panier
app.post('/api/cart/:userId/clear', async (req, res) => {
  try {
    let cart = await Cart.findOne({ userId: req.params.userId });
    if (!cart) return res.status(404).json({ error: 'Panier non trouvé' });
    cart.items = [];
    await cart.save();
    res.status(200).json(cart);
  } catch (err) {
    res.status(500).json({ error: 'Erreur lors du vidage du panier' });
  }
});

// Upload d'une image avec description pour loading_image
app.post('/upload-loading-image', upload.single('image'), async (req, res) => {
  try {
    const { description, categorie, customCategorie } = req.body;
    let imagePath = '';
    if (req.file) {
      imagePath = `uploads/${req.file.filename}`;
    }
    const loadingImage = new Loading_image({
      description: description || '',
      image: imagePath,
      categorie: categorie || '',
      customCategorie: customCategorie || '',
    });
    await loadingImage.save()
    res.status(201).json({ message: 'Image et description enregistrées avec succès', loadingImage });
  } catch (err) {
    console.error('Erreur lors de l\'upload de l\'image:', err);
    res.status(500).json({ error: 'Erreur lors de l\'upload de l\'image' });
  }
});
// Récupérer toutes les images et descriptions loading_image
app.get('/api/loading-images', async (req, res) => {
  try {
    const images = await Loading_image.find().sort({ createdAt: -1 });
    res.status(200).json(images);
  } catch (err) {
    res.status(500).json({ error: 'Erreur lors de la récupération des images' });
  }
});
app.use('/uploads', express.static('uploads'));
// supprimer une image loading_image
app.delete('/api/loading-images/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const image = await Loading_image.findByIdAndDelete(id);
    res.status(200).json({ message: 'Image supprimée avec succès', image });
  } catch (err) {
    res.status(500).json({ error: 'Erreur lors de la suppression de l\'image' });
  }
});


const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Serveur démarré sur le port ${PORT}`);
});
