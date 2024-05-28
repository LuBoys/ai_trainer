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

        const prompt = `
        Voici un exemple de programme d'entraînement basé sur les préférences fournies :

        **Introduction**
        - Sexe: ${data.sexe}
        - Poids: ${data.poids} kg
        - Objectif: ${data.objectif}
        - Niveau d'expérience: ${data.niveauExperience}

        **Programme d'entraînement**

        ${generateTrainingPlan(data)}

        **Note**
        Assurez-vous de bien vous échauffer avant chaque séance et de vous étirer après. N'hésitez pas à ajuster les charges et les exercices en fonction de votre niveau d'expérience et de votre confort. Et bien sûr, restez hydraté et respectez votre alimentation pour soutenir vos performances.
        `;

        const response = await axios.post('https://api.openai.com/v1/chat/completions', {
            model: 'gpt-3.5-turbo',
            messages: [
                { role: 'system', content: 'You are a personal training assistant.' },
                { role: 'user', content: prompt }
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

function generateTrainingPlan(data) {
    let plan = '';
    const daysOfTraining = data.nombreJours;
    const trainingDays = [
        "Jour 1", "Jour 2", "Jour 3", "Jour 4", "Jour 5", "Jour 6", "Jour 7"
    ];
    
    for (let i = 0; i < 7; i++) {
        if (i < daysOfTraining) {
            plan += `**${trainingDays[i]} - Entraînement ${data.objectif} (${data.formatEntrainement})**\n`;
            plan += `- Groupes musculaires: ${data.partiesMusculaires.join(', ')}\n`;
            plan += `- Exercices recommandés: [détailler les exercices spécifiques ici]\n`;
            plan += `- Durée de l'entraînement: ${data.tempsEntrainementHeure} heures\n\n`;
        } else {
            plan += `**${trainingDays[i]} - Repos ou Cardio léger**\n`;
            plan += `- Cardio léger pour maintenir l'endurance\n\n`;
        }
    }
    return plan;
}

app.listen(PORT, () => {
    console.log(`Serveur en écoute sur le port ${PORT}`);
});
