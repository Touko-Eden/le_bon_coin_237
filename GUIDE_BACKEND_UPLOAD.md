
# Guide de Mise en Place de l'Upload d'Images

Suivez étape par étape ce guide pour activer l'hébergement des images sur votre backend Node.js.

## 1. Installation des dépendances

Ouvrez le terminal **dans le dossier de votre backend** et lancez :

```bash
npm install multer
```

## 2. Création du Middleware d'Upload

Créez un nouveau fichier `middleware/upload.js` :

```javascript
const multer = require('multer');
const path = require('path');
const fs = require('fs');

// Créer le dossier uploads s'il n'existe pas
const uploadDir = 'uploads/';
if (!fs.existsSync(uploadDir)){
    fs.mkdirSync(uploadDir);
}

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    // Nom unique: timestamp-random.ext
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, 'img-' + uniqueSuffix + path.extname(file.originalname));
  }
});

const fileFilter = (req, file, cb) => {
  if (file.mimetype.startsWith('image/')) {
    cb(null, true);
  } else {
    cb(new Error('Seules les images sont acceptées'), false);
  }
};

module.exports = multer({ 
    storage: storage,
    limits: { fileSize: 10 * 1024 * 1024 }, // 10MB max
    fileFilter: fileFilter 
});
```

## 3. Mise à jour du Contrôleur (controllers/annonceController.js)

Remplacez la fonction `createAnnonce` existante par celle-ci (qui gère à la fois les fichiers et le JSON) :

```javascript
const Annonce = require('../models/Annonce');
const User = require('../models/User');
const { Op } = require('sequelize');
const fs = require('fs');

exports.createAnnonce = async (req, res) => {
  try {
    const { title, description, price, category, condition, location } = req.body;
    
    // ---------------------------------------------------------
    // TRAITEMENT DES IMAGES (Nouveau)
    // ---------------------------------------------------------
    let images = [];
    
    // Cas 1: Fichiers uploadés via Multipart (App Mobile)
    if (req.files && req.files.length > 0) {
        // Crée des URLs complètes pour l'accès public
        const baseUrl = `${req.protocol}://${req.get('host')}`;
        images = req.files.map(file => `${baseUrl}/uploads/${file.filename}`);
    } 
    // Cas 2: URLs envoyées en JSON (Test ou Legacy)
    else if (req.body.images) {
        images = Array.isArray(req.body.images) ? req.body.images : [req.body.images];
    }

    // ---------------------------------------------------------
    // VALIDATION
    // ---------------------------------------------------------
    if (!title || !description || !price || !category || !location) {
      // Nettoyage si erreur validation
      if (req.files) req.files.forEach(f => fs.unlinkSync(f.path));
      
      return res.status(400).json({ 
          success: false, 
          message: 'Veuillez fournir tous les champs requis (titre, description, prix, catégorie, localisation)' 
      });
    }

    if (images.length < 3) {
      if (req.files) req.files.forEach(f => fs.unlinkSync(f.path));
      
      return res.status(400).json({ 
          success: false, 
          message: 'Au moins 3 images sont requises' 
      });
    }

    // ---------------------------------------------------------
    // CRÉATION DE L'ANNONCE
    // ---------------------------------------------------------
    const annonce = await Annonce.create({
      title,
      description,
      price: parseFloat(price), // Assure que le prix est un nombre
      category,
      condition: condition || 'Bon état',
      location,
      images: images, // Sequelize gère le tableau grâce à DataTypes.JSON
      userId: req.user.id
    });

    // Récupérer l'annonce avec infos vendeur
    const annonceWithSeller = await Annonce.findByPk(annonce.id, {
      include: [{
        model: User,
        as: 'seller',
        attributes: ['id', 'fullName', 'phone', 'location', 'avatar']
      }]
    });

    res.status(201).json({
      success: true,
      message: 'Annonce créée avec succès',
      data: annonceWithSeller
    });

  } catch (error) {
    console.error('Erreur createAnnonce:', error);
    // Nettoyage en cas d'erreur DB
    if (req.files) {
        req.files.forEach(f => {
            if (fs.existsSync(f.path)) fs.unlinkSync(f.path);
        });
    }
    
    res.status(500).json({
      success: false,
      message: 'Erreur lors de la création de l\'annonce',
      error: error.message
    });
  }
};
```

## 4. Mise à jour des Routes (routes/annonceRoutes.js)

Importez le middleware et ajoutez-le à la route POST :

```javascript
const express = require('express');
const router = express.Router();
const annonceController = require('../controllers/annonceController');
const { protect } = require('../middleware/authMiddleware');
const upload = require('../middleware/upload'); // <--- AJOUTER CECI

// Routes publiques
router.get('/', annonceController.getAnnonces);
router.get('/:id', annonceController.getAnnonceById);
router.get('/user/:userId', annonceController.getUserAnnonces);

// Routes protégées
// MODIFIER CETTE LIGNE :
router.post('/', protect, upload.array('images', 5), annonceController.createAnnonce);

router.put('/:id', protect, annonceController.updateAnnonce);
router.delete('/:id', protect, annonceController.deleteAnnonce);
router.get('/my/annonces', protect, annonceController.getMyAnnonces);

module.exports = router;
```

## 5. Configuration du Serveur (app.js ou server.js)

Pour que les images soient accessibles (affichables dans l'app), vous devez rendre le dossier `uploads` public. Ajoutez ceci dans votre `app.js` (avant les routes) :

```javascript
const path = require('path');

// Rendre le dossier uploads accessible publiquement
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
```

Une fois ces modifications faites, redémarrez votre serveur backend.
