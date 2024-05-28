const express = require('express');
const axios = require('axios');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.post('/api/generate-program', async (req, res) => {
    try {
        const { data } = req.body;

        if (!data) {
            return res.status(400).json({ message: 'Données manquantes dans la requête.' });
        }

        const response = await axios.post('https://api.openai.com/v1/chat/completions', {
            model: 'gpt-3.5-turbo',
            messages: [
                { role: 'system', content: 'You are a personal training assistant.' },
                { role: 'user', content: `Générer un programme d'entraînement basé sur: ${JSON.stringify(data)}` }
            ],
            max_tokens: 500
        }, {
            headers: {
                'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`,
                'Content-Type': 'application/json'
            }
        });

        res.status(200).json({ result: response.data.choices[0].message.content });
    } catch (error) {
        console.error('Erreur lors de la génération du programme:', error);

        if (error.response) {
            res.status(error.response.status).json({ message: error.response.data });
        } else if (error.request) {
            res.status(503).json({ message: 'Service indisponible. Veuillez réessayer plus tard.' });
        } else {
            res.status(500).json({ message: 'Erreur interne du serveur.' });
        }
    }
});

app.listen(PORT, () => {
    console.log(`Serveur en écoute sur le port ${PORT}`);
});
