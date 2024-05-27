const express = require('express');
const axios = require('axios');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.post('/generate-program', async (req, res) => {
    try {
        const { data } = req.body;

        // Validation des données entrantes
        if (!data) {
            return res.status(400).json({ message: 'Données manquantes dans la requête.' });
        }

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

        // Amélioration de la gestion des erreurs
        if (error.response) {
            // Erreur provenant de l'API OpenAI
            res.status(error.response.status).json({ message: error.response.data });
        } else if (error.request) {
            // Aucune réponse reçue de l'API OpenAI
            res.status(503).json({ message: 'Service indisponible. Veuillez réessayer plus tard.' });
        } else {
            // Autres erreurs
            res.status(500).json({ message: 'Erreur interne du serveur.' });
        }
    }
});

app.listen(PORT, () => {
    console.log(`Serveur en écoute sur le port ${PORT}`);
});
