const { supabase } = require('../config/supabaseClient');
const jwt = require('jsonwebtoken');
require('dotenv').config();

exports.adminLogin = async (req, res) => {
    const { email, password } = req.body;

    try {
        const { data, error } = await supabase
            .from('admin')
            .select('*')
            .eq('email', email)
            .single();

        if (error || !data) {
            return res.status(400).json({ message: 'Admin not found' });
        }

        if (data.password !== password) {
            return res.status(401).json({ message: 'Invalid credentials' });
        }

        const token = jwt.sign({ id: data.id, role: 'admin' }, process.env.JWT_SECRET, {
            expiresIn: '1d',
        });

        res.json({
            message: 'Login successful',
            token,
            admin: { id: data.id, name: data.name, email: data.email },
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Server error' });
    }
};

// POST /api/auth/farmer/login
exports.loginFarmer = async (req, res) => {
    try {
        const { mobile_number } = req.body;

        if (!mobile_number) {
            return res.status(400).json({ message: 'mobile_number is required' });
        }

        const { data, error } = await supabase
            .from('farmer')
            .select('*')
            .eq('mobile_number', mobile_number)
            .single();

        if (error || !data) {
            return res.status(404).json({ message: 'Farmer not found' });
        }

        if (data.status !== 'approved') {
            return res.status(403).json({ message: 'Account not approved yet' });
        }

        return res.status(200).json({
            message: 'Login successful',
            farmer: {
                name: data.name,
                farmer_id: data.farmer_id,
                mobile_number: data.mobile_number,
                profile_picture_url: data.profile_picture_url
            }
        });
    } catch (err) {
        console.error('Login error:', err.message);
        res.status(500).json({ message: 'Something went wrong. Please try again later.' });
    }
};