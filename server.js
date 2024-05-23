const express = require('express');
const axios = require('axios');
require('dotenv').config(); // Charger les variables d'environnement à partir du fichier .env

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.post('/generate-program', async (req, res) => {
    try {
        const { data } = req.body; // Assurez-vous de valider et de sécuriser les données entrantes

        const response = await axios.post('https://api.openai.com/v1/engines/davinci/completions', {
            prompt: "Générer un programme d'entraînement basé sur: " + JSON.stringify(data),
            max_tokens: 500
        }, {
            headers: {
                'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`,
                'Content-Type': 'application/json'
            }            
        });

        res.status(200).json(response.data);
    } catch (error) {
        console.error('Erreur lors de la génération du programme:', error);
        res.status(500).json({ message: 'Erreur interne du serveur' });
    }
});

app.listen(PORT, () => {
    console.log(`Serveur en écoute sur le port ${PORT}`);
});
