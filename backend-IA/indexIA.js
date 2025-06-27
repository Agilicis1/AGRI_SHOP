const express = require('express');
const multer = require('multer');
const fs = require('fs');
const axios = require('axios');
const cors = require('cors');
require('dotenv').config();

const app = express();
const upload = multer({ dest: 'uploads/' });
app.use(cors());

app.post('/analyze-image', upload.single('image'), async (req, res) => {
  let tempFilePath = null;
  try {
    console.log("la requette pour analyser l'image est reçue");
    if (!req.file) {
      console.log('Aucune image reçue');
      // 400 : bad request
      return res.status(400).json({ error: 'Aucune image reçue.' });
    }
    tempFilePath = req.file.path;
    // Lire le fichier image
    console.log('Lecture du fichier image...');
    const imageData = fs.readFileSync(tempFilePath);

    // Vérification de la clé API
    const openaiApiKey = process.env.OPENAI_API_KEY;
    if (!openaiApiKey) {
      console.log('Clé API OpenAI manquante');
      // 500 : internal server error
      return res.status(500).json({ error: 'Clé API OpenAI manquante.' });
    }
    const openaiHeaders = {
      'Authorization': `Bearer ${openaiApiKey}`,
      'Content-Type': 'application/json'
    };

    // Appel direct à l'API OpenAI avec image en base64
    console.log('Envoi de l\'image à OpenAI...');
    const completionResponse = await axios.post(
      'https://api.openai.com/v1/chat/completions',
      {
        model: 'gpt-4.1-mini',
        messages: [
          {
            role: 'user',
            content: [
              { type: 'text', text: 'tu es un assistant expert dans la maladie des plantes en afrique, tu analyseras les plantes fournies et me diras de quelle (type de plante s\'agit il ,quelle type de maladie il s\'agit, une description simple de la maladie si tu identifie une maladie , si la plante n\'est pas malade alors tu dis que la plante est en bonne santée, et un produit pour la soigner. Ta réponse doit être structurée (nom de la plante, nom de la maladie, description de la maladie, produit pour soigner la maladie, tu devras fournire des reponses fiables sur la detection de maladie( pas d\'approximation)).' },
              {
                type: 'image_url',
                image_url: {
                  url: `data:image/jpeg;base64,${imageData.toString('base64')}`
                }
              }
            ]
          }
        ],
        max_tokens: 1000
      },
      { headers: openaiHeaders, timeout: 20000 }
    );

    fs.unlinkSync(tempFilePath);

    // Extraire la réponse de l'assistant
    const resultText = completionResponse.data.choices[0].message.content;
    console.log('Réponse Assistant reçue');
    res.json({ result: resultText });
  } catch (error) {
    if (tempFilePath && fs.existsSync(tempFilePath)) {
      fs.unlinkSync(tempFilePath);
    }
    console.error('Erreur détaillée:', error.response ? error.response.data : error.message);
    res.status(500).json({ error: 'Erreur lors du traitement de l\'image.' });
  }
});

app.listen(3001, () => {
  console.log('Serveur backend IA démarré sur le port 3001');
});