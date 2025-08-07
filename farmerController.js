const { supabase } = require('../config/supabaseClient');
const multer = require('multer');
const fs = require('fs');
const path = require('path');
const axios = require('axios');
const { GoogleGenerativeAI } = require("@google/generative-ai");
require('dotenv').config();
// Initialize Gemini
const genAI = new GoogleGenerativeAI(process.env.AI_API);



// Upload base64 image to Supabase
const uploadToSupabase = async (base64Data, folder, fileName) => {
    const base64 = base64Data.split(';base64,').pop(); // remove header
    const buffer = Buffer.from(base64, 'base64');

    const fullPath = `${folder}/${Date.now()}-${fileName}`;

    const { error: uploadError } = await supabase
        .storage
        .from('farmer-docs')
        .upload(fullPath, buffer, {
            contentType: 'image/jpeg', // you can make this dynamic if needed
        });

    if (uploadError) {
        throw new Error(`Upload failed: ${uploadError.message}`);
    }

    const { data } = supabase
        .storage
        .from('farmer-docs')
        .getPublicUrl(fullPath);

    return data.publicUrl;
};

const generateFarmerId = () => {
    const randomNum = Math.floor(Math.random() * 900) + 100; // Generates a random 3-digit number (100-999)
    return `farm${randomNum}`;
};

exports.registerFarmer = async (req, res) => {
    try {
        const { name, mobile, address, aadharCard, landRecord, profilePic, rationCard } = req.body;

        if (!name || !mobile || !address || !aadharCard || !landRecord || !profilePic || !rationCard) {
            return res.status(400).json({ message: 'All fields and documents are required' });
        }

        const farmerId = generateFarmerId();

        const aadharUrl = await uploadToSupabase(aadharCard, `aadhar/${farmerId}`, 'aadhar.jpg');
        const landRecordUrl = await uploadToSupabase(landRecord, `land/${farmerId}`, 'land.jpg');
        const profilePicUrl = await uploadToSupabase(profilePic, `profile/${farmerId}`, 'profile.jpg');
        const rationCardUrl = await uploadToSupabase(rationCard, `ration/${farmerId}`, 'ration.jpg');

        // Insert into Supabase
        const { error } = await supabase
            .from('farmer')
            .insert([{
                name,
                mobile_number: mobile,
                farmer_id: farmerId,
                aadhar_image_url: aadharUrl,
                land_record_url: landRecordUrl,
                profile_picture_url: profilePicUrl,
                ration_card_url: rationCardUrl,
                status: 'pending',
                created_at: new Date(),
                address: address
            }]);


        if (error) {
            console.error('Supabase error:', error);
            return res.status(500).json({ message: 'Database insert failed' });
        }

        res.status(200).json({ message: 'Registration successful. Waiting for approval.' });
    } catch (err) {
        console.error('Registration error:', err);
        res.status(500).json({ message: 'Server error' });
    }
};

// GET /api/farmers/pending
exports.getPendingFarmers = async (req, res) => {
    try {
        const { data, error } = await supabase
            .from('farmer')
            .select('*')
            .eq('status', 'pending');

        if (error) {
            console.error('Supabase fetch error:', error);
            return res.status(500).json({ message: 'Failed to fetch farmers' });
        }

        res.status(200).json(data);
    } catch (err) {
        console.error('Server error:', err);
        res.status(500).json({ message: 'Server error' });
    }
};

// PUT /api/farmers/approve/:id
exports.approveFarmer = async (req, res) => {
    const farmerId = req.params.id;
    const { data, error } = await supabase
        .from('farmer')
        .update({ status: 'approved' })
        .eq('farmer_id', farmerId);

    if (error) {
        return res.status(500).json({ message: 'Approval failed' });
    }
    res.status(200).json({ message: 'Farmer approved successfully' });
};

// Reject Farmer (delete)
exports.rejectFarmer = async (req, res) => {
    const farmerId = req.params.id;
    const { error } = await supabase
        .from('farmer')
        .delete()
        .eq('farmer_id', farmerId);

    if (error) {
        return res.status(500).json({ message: 'Rejection failed' });
    }
    res.status(200).json({ message: 'Farmer rejected and removed' });
};

// GET /api/farmerdata/:id
exports.getFarmersDetails = async (req, res) => {
    const farmerId = req.params.id;
    console.log('Fetching farmer with ID:', farmerId);

    const { data, error } = await supabase
        .from('farmer')
        .select('*') // or list specific fields like 'name, email, phone'
        .eq('farmer_id', farmerId)
        .single(); // get only one row

    if (error || !data) {
        return res.status(404).json({ message: 'Farmer not found' });
    }

    res.status(200).json(data);
};

// PUT /api/farmerdata/:id
exports.updateFarmersDetails = async (req, res) => {
    const farmerId = req.params.id;

    const {
        name,
        mobile_number,
        address,
        aadhar_image_url,
        land_record_url,
        profile_picture_url,
        ration_card_url,
        status
    } = req.body;

    console.log(`Updating farmer with ID: ${farmerId}`);

    // 🔒 Validation
    if (!name || !mobile_number) {
        return res.status(400).json({
            message: 'Name and Mobile Number are required fields.'
        });
    }

    try {
        const { data, error } = await supabase
            .from('farmer')
            .update({
                name,
                mobile_number,
                address,
                aadhar_image_url,
                land_record_url,
                profile_picture_url,
                ration_card_url,
                status
            })
            .eq('farmer_id', farmerId)
            .select()
            .single();

        if (error) {
            console.error('Error updating farmer:', error);
            return res.status(500).json({ message: 'Failed to update farmer data', error });
        }

        res.status(200).json({
            message: 'Farmer data updated successfully',
            updatedData: data
        });
    } catch (err) {
        console.error('Unexpected server error:', err);
        res.status(500).json({ message: 'Server error' });
    }
};

exports.saveSupplementOrder = async (req, res) => {
    const { farmerid, username, phoneno, address1, supplements } = req.body;

    console.log(`Saving supplement order for Farmer ID: ${farmerid}`);

    // 🔒 Validation
    if (!farmerid || !username || !phoneno || !address1 || !supplements || supplements.length === 0) {
        return res.status(400).json({
            message: 'All fields (farmerid, username, phoneno, address1, supplements) are required.'
        });
    }

    try {
        const { data, error } = await supabase
            .from('supplements') // 👉 your table name
            .insert([
                {
                    farmerid: farmerid,
                    username: username,
                    phoneno: phoneno,
                    address1: address1,
                    supplements: JSON.stringify(supplements), // 🛠️ FIX: stringify here
                    created_at: new Date(),
                    status: 'ordered'
                }
            ])
            .select()
            .single();

        if (error) {
            console.error('Error saving supplement order:', error);
            return res.status(500).json({ message: 'Failed to save supplement order', error });
        }

        res.status(200).json({
            message: 'Supplement order saved successfully',
            orderData: data
        });
    } catch (err) {
        console.error('Unexpected server error:', err);
        res.status(500).json({ message: 'Server error' });
    }
};

exports.getSupplementOrdersByFarmerId = async (req, res) => {
    const farmerid = req.params.id;

    console.log(`Fetching supplement orders for Farmer ID: ${farmerid}`);

    // 🔒 Validation
    if (!farmerid) {
        return res.status(400).json({
            message: 'Farmer ID is required.'
        });
    }

    try {
        const { data, error } = await supabase
            .from('supplements') // 👉 your table name
            .select('*')
            .eq('farmerid', farmerid) // Filter by farmerid
            .order('created_at', { ascending: false }); // Optional: to get the most recent orders first

        if (error) {
            console.error('Error fetching supplement orders:', error);
            return res.status(500).json({ message: 'Failed to fetch supplement orders', error });
        }

        if (data.length === 0) {
            return res.status(404).json({
                message: 'No supplement orders found for this Farmer ID.'
            });
        }

        res.status(200).json({
            message: 'Supplement orders fetched successfully',
            orders: data
        });
    } catch (err) {
        console.error('Unexpected server error:', err);
        res.status(500).json({ message: 'Server error' });
    }
};

exports.getAllSupplementOrders = async (req, res) => {
    console.log(`Fetching supplement orders with status: ${req.query.status || 'all'}`);

    try {
        const { status } = req.query; // Get status from query parameters

        // Validate if status is provided and it's either 'all' or a valid status
        if (status && status.trim() === '') {
            return res.status(200).json({ message: 'Invalid status value. Please provide a valid status.' });
        }

        let query = supabase.from('supplements').select('*');

        if (status && status !== 'all') {
            // Validate allowed status values (if it's not 'all', it should be one of the valid statuses)
            const allowedStatuses = ['ordered', 'accepted', 'delivered', 'cancelled'];
            if (!allowedStatuses.includes(status)) {
                return res.status(200).json({ message: 'Invalid status value. Accepted values are ordered, accepted, delivered, cancelled.' });
            }
            query = query.eq('status', status); // Add status filter if it's provided
        }

        const { data, error } = await query;

        if (error) {
            console.error('Error fetching supplement orders:', error);
            return res.status(500).json({ message: 'Failed to fetch supplement orders', error });
        }

        if (!data || data.length === 0) {
            return res.status(200).json({
                message: 'No supplement orders found.'
            });
        }

        // Custom sort: ordered → accepted → others
        const sortedOrders = data.sort((a, b) => {
            const priority = { ordered: 0, accepted: 1 };
            return (priority[a.status] ?? 2) - (priority[b.status] ?? 2);
        });

        res.status(200).json({
            message: 'Supplement orders fetched successfully',
            orders: sortedOrders
        });
    } catch (err) {
        console.error('Unexpected server error:', err);
        res.status(500).json({ message: 'Server error' });
    }
};


exports.updateSupplementOrderStatus = async (req, res) => {
    const { id } = req.params; // Order ID
    const { status } = req.body; // New status to be updated

    console.log(`Updating status for order ID: ${id} to ${status}`);

    // 🔒 Validate input
    if (!id || !status) {
        return res.status(400).json({ message: 'Order ID and status are required.' });
    }

    // ✅ Validate allowed status values
    const allowedStatuses = ['ordered', 'accepted', 'delivered', 'cancelled'];
    if (!allowedStatuses.includes(status)) {
        return res.status(400).json({ message: 'Invalid status value.' });
    }

    try {
        const { data, error } = await supabase
            .from('supplements')
            .update({ status })
            .eq('id', id)
            .select();

        if (error) {
            console.error('Error updating supplement order status:', error);
            return res.status(500).json({ message: 'Failed to update status', error });
        }

        if (!data || data.length === 0) {
            return res.status(404).json({ message: 'Order not found.' });
        }

        res.status(200).json({
            message: 'Status updated successfully.',
            order: data[0]
        });
    } catch (err) {
        console.error('Unexpected server error:', err);
        res.status(500).json({ message: 'Server error' });
    }
};


// Controller method for handling plant image upload
// exports.uploadPlantImage = async (req, res) => {
//     try {
//         // Get the uploaded image file path
//         const imagePath = req.file.path;

//         // Convert the image to Base64
//         const imageBase64 = fs.readFileSync(imagePath, { encoding: 'base64' });

//         // Make an API request to the crop identification service
//         const response = await axios.post(
//             'https://crop.kindwise.com/api/v1/identification',
//             {
//                 images: [imageBase64], // Send the Base64 encoded image
//             },
//             {
//                 params: {
//                     details: 'common_names,type,taxonomy,eppo_code,eppo_regulation_status,gbif_id,image,images,wiki_url,wiki_description,treatment,description,symptoms,severity,spreading',
//                     language: 'en',
//                 },
//                 headers: {
//                     'Api-Key': 'xPA4ck3RCzy7K9k66DC21baYa4K2or0bFrR4LKHRSipeof3yxd', // Replace with your actual API key
//                     'Content-Type': 'application/json',
//                 },
//             }
//         );

//         // Process the response and return the result
//         const identification = response.data;

//         // Delete the image from the server after processing
//         fs.unlinkSync(imagePath);

//         // Return the identification result
//         res.json({
//             message: 'Plant image identified successfully',
//             data: identification,
//         });
//     } catch (error) {
//         console.error(error.response?.data || error.message);

//         // Send a response in case of failure
//         res.status(500).json({
//             message: 'Error identifying the plant image.',
//             error: error.message,
//         });
//     }
// };

// exports.uploadPlantImage = async (req, res) => {
//     try {
//         const imageBase64 = req.body.image;

//         // Step 1: Insert the image into Supabase
//         const { data, error } = await supabase
//             .from('cropimages')
//             .insert([{ images: imageBase64 }])
//             .select();

//         if (error) {
//             console.error('Error inserting image into cropimages:', error);
//             return res.status(500).json({ message: 'Failed to insert image into cropimages table', error });
//         }

//         if (!data || data.length === 0) {
//             return res.status(500).json({ message: 'No data returned after insert' });
//         }

//         const insertedImage = data[0].images; // Base64 Image inserted

//         // Step 2: Send to Crop Identification API
//         const cropResponse = await axios.post(
//             'https://crop.kindwise.com/api/v1/identification',
//             {
//                 images: [insertedImage], // Send Base64 image
//             },
//             {
//                 params: {
//                     details: 'common_names,type,taxonomy,image,wiki_url,wiki_description,treatment,description,symptoms,severity,spreading',
//                     language: 'en',
//                 },
//                 headers: {
//                     'Api-Key': 'xPA4ck3RCzy7K9k66DC21baYa4K2or0bFrR4LKHRSipeof3yxd',
//                     'Content-Type': 'application/json',
//                 },
//             }
//         );

//         console.log('Crop Response:', JSON.stringify(cropResponse.data, null, 2));

//         // Validate and process crop suggestions
//         const cropSuggestions = (cropResponse.data?.result?.crop?.suggestions && Array.isArray(cropResponse.data.result.crop.suggestions))
//             ? cropResponse.data.result.crop.suggestions.map(crop => ({
//                 name: crop?.name || null,
//                 probability: crop?.probability || 0,
//                 scientific_name: crop?.scientific_name || null,
//             }))
//             : []; // Return empty array if no suggestions or not an array

//         // Validate and process disease suggestions
//         const diseaseSuggestions = (cropResponse.data?.result?.disease?.suggestions && Array.isArray(cropResponse.data.result.disease.suggestions))
//             ? cropResponse.data.result.disease.suggestions.map(disease => ({
//                 name: disease?.name || null,
//                 probability: disease?.probability || 0,
//                 common_names: disease?.details?.common_names || null,
//                 disease_type: disease?.details?.type || null,
//                 description: disease?.details?.description || null,
//                 symptoms: disease?.details?.symptoms || null,
//                 severity: disease?.details?.severity || null,
//                 spreading: disease?.details?.spreading || null,
//                 treatment: disease?.details?.treatment || null,
//                 wiki_url: disease?.details?.wiki_url || null,
//             }))
//             : []; // Return empty array if no suggestions or not an array

//         return res.status(200).json({
//             cropSuggestions,
//             diseaseSuggestions,
//         });

//     } catch (error) {
//         console.error('Error uploading plant image:', error);
//         return res.status(500).json({ message: 'Failed to upload plant image', error });
//     }
// };
exports.uploadPlantImage = async (req, res) => {
    try {
        const imageBase64 = req.body.image;
        const languageCode = req.body.language || 'en'; // default to English if not provided

        // Insert image into Supabase (unchanged)
        const { data, error } = await supabase
            .from('cropimages')
            .insert([{ images: imageBase64 }])
            .select();

        if (error || !data || data.length === 0) {
            return res.status(500).json({ message: 'Error inserting image to DB', error });
        }

        // Convert image to buffer
        const base64Data = imageBase64.replace(/^data:image\/\w+;base64,/, '');
        const buffer = Buffer.from(base64Data, 'base64');

        // Select prompt language
        let promptText = '';

        switch (languageCode) {
            case 'hi':
                promptText = "इस फसल की बीमारी की छवि का विश्लेषण करें और निम्नलिखित विवरण हिंदी में दें:\n" +
                    "1. फसल का नाम\n" +
                    "2. बीमारी का विवरण\n" +
                    "3. उपचार या रोकथाम के लिए सिफारिश की गई खाद या पूरक";
                break;
            case 'ta':
                promptText = "இந்த பயிர் நோய் படத்தை பகுப்பாய்வு செய்து கீழ்காணும் விவரங்களை தமிழில் கொடுக்கவும்:\n" +
                    "1. பயிரின் பெயர்\n" +
                    "2. நோயின் விளக்கம்\n" +
                    "3. சிகிச்சை அல்லது தடுப்பு உரைகள்/துணைப்பொருட்கள்";
                break;
            case 'ml':
                promptText = "ഈ വിള രോഗ ചിത്രത്തെ വിശകലനം ചെയ്ത് താഴെ പറയുന്ന വിശദാംശങ്ങൾ മലയാളത്തിൽ നൽകുക:\n" +
                    "1. വിളയുടെ പേര്\n" +
                    "2. രോഗത്തിന്റെ വിവരണം\n" +
                    "3. ചികിത്സയ്‌ക്കും പ്രതിരോധത്തിനുമുള്ള സപ്ലിമെന്റുകൾ";
                break;
            default:
                promptText = "Analyze this crop disease image and provide the following details in English:\n" +
                    "1. Crop Name\n" +
                    "2. Description of the disease\n" +
                    "3. Recommended Supplements to treat or prevent it";
        }
        console.log("The promptText :", promptText);
        // Use Gemini Vision API
        const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash", });

        const result = await model.generateContent([
            {
                inlineData: {
                    mimeType: "image/jpeg",
                    data: base64Data,
                }
            },
            {
                text: promptText
            }
        ]);

        const response = await result.response;
        const text = await response.text();

        return res.status(200).json({
            language: languageCode,
            analysis: text
        });

    } catch (error) {
        console.error('Error processing image with Gemini:', error);
        return res.status(500).json({ message: 'Failed to analyze image with Gemini API', error });
    }
};
