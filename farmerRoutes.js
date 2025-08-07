const express = require('express');
const multer = require('multer');
const router = express.Router();
const farmerController = require('../controllers/farmerController');

// Set up multer for file uploads
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'src/uploads/'); // Specify the upload folder
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + '-' + file.originalname); // Ensure unique filenames
    }
});

const upload = multer({ storage: storage });

router.post('/register', farmerController.registerFarmer);
router.put('/approve/:id', farmerController.approveFarmer);
router.delete('/reject/:id', farmerController.rejectFarmer);
router.get('/pending', farmerController.getPendingFarmers);

//using former id getting the former details
router.get('/farmerdata/:id', farmerController.getFarmersDetails);
router.put('/farmerdata/:id', farmerController.updateFarmersDetails);

router.post('/supplements', farmerController.saveSupplementOrder);
router.get('/getsupplements/:id', farmerController.getSupplementOrdersByFarmerId);

router.get('/getallsupplements', farmerController.getAllSupplementOrders);
router.put('/getallsupplements/:id', farmerController.updateSupplementOrderStatus);

router.post('/cropdiagnosis', farmerController.uploadPlantImage);

module.exports = router;
