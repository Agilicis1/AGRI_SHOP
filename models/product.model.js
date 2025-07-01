const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  price: {
    type: Number,
    required: true,
  },
  description: {
    type: String,
    required: false,
  },
  image: {
    type: String,
    required: false,
  },
  quantity: {
    type: Number,
    required: false,
  },    
  categorie : {
    type : String,
    enum : ['Herbicides', 'Fongicides', 'Insecticides', 'Nématicides','autres'],
    required : true,
}
}, { timestamps: true });

const Product = mongoose.model('Product', productSchema);
// exporter le model de produit 
module.exports = Product;

