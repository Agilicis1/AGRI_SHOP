const mongoose = require('mongoose');

const loading_image = new mongoose.Schema({

  description: {
    type: String,
    required: false,
  },
  image: {
    type: String,
    required: false,
  },
  categorie : {
    type : String,
    enum : ['Herbicides', 'Fongicides', 'Insecticides', 'Nématicides'],
    required : true,
  }
}, { timestamps: true });

const Loading_image = mongoose.model('Loading_image', loading_image);
// exporter le model de produit 
module.exports = Loading_image;

