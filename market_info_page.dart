import 'package:crop_frontend/widgets/language_switcher.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

class MarketInfoPage extends StatefulWidget {
  final Function(Locale) onLocaleChange;
  const MarketInfoPage({super.key, required this.onLocaleChange});

  @override
  State<MarketInfoPage> createState() => _MarketInfoPageState();
}

class _MarketInfoPageState extends State<MarketInfoPage> {
  String selectedDistrict = 'Chennai';
  String _currentLang = 'en';

  final Map<String, Map<String, String>> localizedDistricts = {
    "Kancheepuram": {
      "en": "Kancheepuram",
      "ta": "காஞ்சிபுரம்",
      "hi": "कांचीपुरम",
      "ml": "കാഞ്ചിപുരം"
    },
    "Thiruvallur": {
      "en": "Thiruvallur",
      "ta": "திருவள்ளூர்",
      "hi": "तिरुवल्लूर",
      "ml": "തിരുവള്ളൂർ"
    },
    "Cuddalore": {
      "en": "Cuddalore",
      "ta": "கடலூர்",
      "hi": "कुड्डलोर",
      "ml": "കഡലൂർ"
    },
    "Erode": {"en": "Erode", "ta": "ஈரோடு", "hi": "ईरोड", "ml": "ഇറോഡ്"},
    "Coimbatore": {
      "en": "Coimbatore",
      "ta": "கோயம்புத்தூர்",
      "hi": "कोयंबटूर",
      "ml": "കോയമ്പത്തൂർ"
    },
    "Chennai": {
      "en": "Chennai",
      "ta": "சென்னை",
      "hi": "चेन्नई",
      "ml": "ചെന്നൈ"
    },
    "Namakkal": {
      "en": "Namakkal",
      "ta": "நாமக்கல்",
      "hi": "नमक्कल",
      "ml": "നാമക്കൽ"
    },
    "Salem": {"en": "Salem", "ta": "சேலம்", "hi": "सेलम", "ml": "സേലം"},
    "Dharmapuri": {
      "en": "Dharmapuri",
      "ta": "தர்மபுரி",
      "hi": "धर्मपुरी",
      "ml": "ധര്‍മപുരി"
    },
    "Ariyalur": {
      "en": "Ariyalur",
      "ta": "அரியலூர்",
      "hi": "अरियालुर",
      "ml": "അരിയലൂര്‍"
    },
    "Chengalpattu": {
      "en": "Chengalpattu",
      "ta": "செங்கல்பட்டு",
      "hi": "चेंगलपट्टू",
      "ml": "ചെംഗല്‍പട്ട്"
    },
    "Dindigul": {
      "en": "Dindigul",
      "ta": "திண்டுக்கல்",
      "hi": "डिंडीगुल",
      "ml": "ഡിണ്ടിഗല്‍"
    },
    "Kallakurichi": {
      "en": "Kallakurichi",
      "ta": "கள்ளக்குறிச்சி",
      "hi": "कल्लाकुरिची",
      "ml": "കല്ലക്കുറിച്ചി"
    },
    "Kanniyakumari": {
      "en": "Kanniyakumari",
      "ta": "கன்னியாகுமரி",
      "hi": "कन्याकुमारी",
      "ml": "കന്യാകുമാരി"
    },
    "Karur": {"en": "Karur", "ta": "கரூர்", "hi": "करूर", "ml": "കരൂര്‍"},
    "Krishnagiri": {
      "en": "Krishnagiri",
      "ta": "கிருஷ்ணகிரி",
      "hi": "कृष्णागिरि",
      "ml": "കൃഷ്ണഗിരി"
    },
    "Madurai": {"en": "Madurai", "ta": "மதுரை", "hi": "मदुरै", "ml": "മദുരൈ"},
    "Mayiladuthurai": {
      "en": "Mayiladuthurai",
      "ta": "மயிலாடுதுறை",
      "hi": "मयिलाडुथुरै",
      "ml": "മയിലാടുതുരൈ"
    },
    "Nagapattinam": {
      "en": "Nagapattinam",
      "ta": "நாகப்பட்டினம்",
      "hi": "नागपट्टिनम",
      "ml": "നാഗപ്പട്ടിണം"
    },
    "Nilgiris": {
      "en": "Nilgiris",
      "ta": "நீலகிரி",
      "hi": "नीलगिरी",
      "ml": "നീലഗിരി"
    },
    "Perambalur": {
      "en": "Perambalur",
      "ta": "பெரம்பலூர்",
      "hi": "पेरम्बलूर",
      "ml": "പെരമ്പലൂര്‍"
    },
    "Pudukkottai": {
      "en": "Pudukkottai",
      "ta": "புதுக்கோட்டை",
      "hi": "पुडुकोट्टै",
      "ml": "പുതുക്കോട്ടെ"
    },
    "Ramanathapuram": {
      "en": "Ramanathapuram",
      "ta": "இராமநாதபுரம்",
      "hi": "रामनाथपुरम",
      "ml": "രാമനാഥപുരം"
    },
    "Ranipet": {
      "en": "Ranipet",
      "ta": "ராணிப்பேட்டை",
      "hi": "रानीपेट",
      "ml": "റാണിപേട്ട്"
    },
    "Sivagangai": {
      "en": "Sivagangai",
      "ta": "சிவகங்கை",
      "hi": "सिवगंगई",
      "ml": "സിവഗംഗൈ"
    },
    "Tenkasi": {
      "en": "Tenkasi",
      "ta": "தென்காசி",
      "hi": "तेनकासी",
      "ml": "തെങ്കാശി"
    },
    "Thanjavur": {
      "en": "Thanjavur",
      "ta": "தஞ்சாவூர்",
      "hi": "तंजावुर",
      "ml": "തഞ്ചാവൂര്‍"
    },
    "Theni": {"en": "Theni", "ta": "தேனி", "hi": "थेनी", "ml": "തേനി"},
    "Thoothukudi": {
      "en": "Thoothukudi",
      "ta": "தூத்துக்குடி",
      "hi": "तूत्तुकुडी",
      "ml": "തൂത്തുക്കുടി"
    },
    "Tiruchirappalli": {
      "en": "Tiruchirappalli",
      "ta": "திருச்சிராப்பள்ளி",
      "hi": "तिरुचिरापल्ली",
      "ml": "തിരുച്ചിറപ്പള്ളി"
    },
    "Tirunelveli": {
      "en": "Tirunelveli",
      "ta": "திருநெல்வேலி",
      "hi": "तिरुनेलवेली",
      "ml": "തിരുനെല്‍വേലി"
    },
    "Tirupathur": {
      "en": "Tirupathur",
      "ta": "திருப்பத்தூர்",
      "hi": "तिरुपत्तूर",
      "ml": "തിരുപത്തൂര്‍"
    },
    "Tiruppur": {
      "en": "Tiruppur",
      "ta": "திருப்பூர்",
      "hi": "तिरुप्पुर",
      "ml": "തിരുപ്പൂര്‍"
    },
    "Tiruvannamalai": {
      "en": "Tiruvannamalai",
      "ta": "திருவண்ணாமலை",
      "hi": "तिरुवन्नामलाई",
      "ml": "തിരുവണ്ണാമലൈ"
    },
    "Tiruvarur": {
      "en": "Tiruvarur",
      "ta": "திருவாரூர்",
      "hi": "तिरुवारूर",
      "ml": "തിരുവാരൂര്‍"
    },
    "Vellore": {
      "en": "Vellore",
      "ta": "வேலூர்",
      "hi": "वेल्लोर",
      "ml": "വെല്ലൂര്‍"
    },
    "Viluppuram": {
      "en": "Viluppuram",
      "ta": "விழுப்புரம்",
      "hi": "विलुप्पुरम",
      "ml": "വിളുപ്പുറം"
    },
    "Virudhunagar": {
      "en": "Virudhunagar",
      "ta": "விருதுநகர்",
      "hi": "विरुधुनगर",
      "ml": "വിരുദുനഗര്‍"
    }
  };

  final List<String> districts = [
    'Kancheepuram',
    'Thiruvallur',
    'Cuddalore',
    'Erode',
    'Coimbatore',
    'Chennai',
    'Namakkal',
    'Salem',
    'Dharmapuri',
    'Ariyalur',
    'Chengalpattu',
    'Dindigul',
    'Kallakurichi',
    'Kanniyakumari',
    'Karur',
    'Krishnagiri',
    'Madurai',
    'Mayiladuthurai',
    'Nagapattinam',
    'Nilgiris',
    'Perambalur',
    'Pudukkottai',
    'Ramanathapuram',
    'Ranipet',
    'Sivagangai',
    'Tenkasi',
    'Thanjavur',
    'Theni',
    'Thoothukudi',
    'Tiruchirappalli',
    'Tirunelveli',
    'Tirupathur',
    'Tiruppur',
    'Tiruvannamalai',
    'Tiruvarur',
    'Vellore',
    'Viluppuram',
    'Virudhunagar',
  ];

  final List<Map<String, dynamic>> marketData = [
    {
      "name": {"en": "Tomato", "ta": "தக்காளி", "hi": "टमाटर", "ml": "തക്കാളി"},
      "image": "images/marketinfo/tomato.jpg",
      "prices": [
        32,
        29,
        35,
        30,
        25,
        28,
        36,
        34,
        27,
        22,
        38,
        31,
        33,
        29,
        30,
        24,
        28,
        30,
        25,
        26,
        27,
        28,
        36,
        34,
        29,
        31,
        32,
        30,
        28,
        25,
        26,
        27,
        30,
        32,
        34,
        36,
        30,
        29
      ]
    },
    {
      "name": {
        "en": "Potato",
        "ta": "உருளைக்கிழங்கு",
        "hi": "आलू",
        "ml": "ഉരുളക്കിഴങ്ങ്"
      },
      "image": "images/marketinfo/potato.jpg",
      "prices": [
        22,
        20,
        25,
        23,
        24,
        19,
        21,
        26,
        28,
        22,
        23,
        25,
        20,
        18,
        19,
        21,
        22,
        24,
        23,
        25,
        20,
        21,
        26,
        25,
        23,
        22,
        19,
        21,
        24,
        25,
        20,
        19,
        22,
        23,
        24,
        25,
        26,
        27
      ]
    },
    {
      "name": {
        "en": "Small Onion",
        "ta": "சின்ன வெங்காயம்",
        "hi": "छोटी प्याज",
        "ml": "സവാള (ചെറി)"
      },
      "image": "images/marketinfo/small_onion.jpg",
      "prices": [
        60,
        58,
        55,
        63,
        50,
        48,
        52,
        54,
        60,
        62,
        59,
        58,
        61,
        63,
        65,
        60,
        62,
        59,
        57,
        60,
        55,
        53,
        58,
        62,
        64,
        63,
        60,
        58,
        56,
        55,
        54,
        59,
        60,
        62,
        61,
        63,
        64,
        66
      ]
    },
    {
      "name": {"en": "Mango", "ta": "மாம்பழம்", "hi": "आम", "ml": "മാവു"},
      "image": "images/marketinfo/mango.jpg",
      "prices": [
        65,
        60,
        62,
        64,
        66,
        63,
        59,
        67,
        68,
        66,
        60,
        62,
        64,
        65,
        63,
        66,
        67,
        69,
        65,
        64,
        63,
        60,
        58,
        62,
        64,
        67,
        66,
        65,
        68,
        69,
        70,
        60,
        61,
        63,
        64,
        65,
        66,
        68
      ]
    },
    {
      "name": {
        "en": "Brinjal",
        "ta": "கத்தரிக்காய்",
        "hi": "बैंगन",
        "ml": "വഴുതന"
      },
      "image": "images/suppliments/brinjal-veg.jpg",
      "prices": [
        30,
        20,
        43,
        37,
        33,
        38,
        43,
        46,
        34,
        28,
        47,
        34,
        10,
        39,
        23,
        15,
        12,
        24,
        17,
        19,
        30,
        35,
        11,
        15,
        20,
        14,
        49,
        21,
        10,
        37,
        20,
        48,
        29,
        16,
        29,
        10,
        49,
        23
      ]
    },
    {
      "name": {"en": "Carrot", "ta": "கேரட்", "hi": "गाजर", "ml": "ക്യാരറ്റ്"},
      "image": "images/suppliments/carrot-veg.jpg",
      "prices": [
        47,
        23,
        30,
        27,
        43,
        15,
        43,
        29,
        42,
        23,
        19,
        19,
        31,
        18,
        40,
        14,
        13,
        22,
        43,
        34,
        10,
        42,
        21,
        42,
        29,
        20,
        42,
        24,
        46,
        16,
        47,
        28,
        35,
        49,
        12,
        12,
        30,
        32
      ]
    },
    {
      "name": {"en": "Beans", "ta": "பீன்ஸ்", "hi": "फली", "ml": "ബീൻസ്"},
      "image": "images/suppliments/beans-veg.jpg",
      "prices": [
        15,
        38,
        13,
        33,
        10,
        44,
        12,
        30,
        16,
        33,
        38,
        38,
        13,
        47,
        41,
        16,
        27,
        38,
        28,
        36,
        17,
        10,
        21,
        10,
        38,
        46,
        32,
        22,
        12,
        41,
        35,
        13,
        47,
        35,
        33,
        11,
        15,
        36
      ]
    },
    {
      "name": {
        "en": "Beetroot",
        "ta": "பீட்ரூட்",
        "hi": "चकुंदर",
        "ml": "ബീറ്റ്റൂട്ട്"
      },
      "image": "images/suppliments/beetroot-veg.jpg",
      "prices": [
        40,
        37,
        33,
        12,
        26,
        27,
        43,
        15,
        27,
        22,
        40,
        50,
        19,
        25,
        34,
        29,
        40,
        49,
        11,
        43,
        17,
        36,
        40,
        31,
        16,
        39,
        29,
        24,
        26,
        41,
        42,
        37,
        30,
        36,
        31,
        28,
        36,
        38
      ]
    },
    {
      "name": {
        "en": "Bottle Gourd",
        "ta": "சுரைக்காய்",
        "hi": "लौकी",
        "ml": "ചൂരയ്ക്ക"
      },
      "image": "images/suppliments/bottle-gourd-veg.jpg",
      "prices": [
        45,
        12,
        33,
        27,
        21,
        13,
        28,
        42,
        42,
        30,
        27,
        21,
        11,
        11,
        49,
        15,
        20,
        49,
        10,
        39,
        16,
        26,
        41,
        17,
        23,
        18,
        34,
        35,
        41,
        25,
        47,
        37,
        17,
        40,
        34,
        13,
        35,
        43
      ]
    },
    {
      "name": {
        "en": "Cabbage",
        "ta": "முட்டைகோஸ்",
        "hi": "पत्ता गोभी",
        "ml": "മുട്ടകോസ്"
      },
      "image": "images/suppliments/cabbage-veg.jpg",
      "prices": [
        49,
        11,
        25,
        19,
        48,
        11,
        39,
        16,
        12,
        17,
        29,
        37,
        23,
        24,
        26,
        49,
        37,
        42,
        46,
        42,
        26,
        16,
        33,
        44,
        15,
        14,
        14,
        18,
        43,
        32,
        37,
        38,
        13,
        43,
        13,
        34,
        31,
        38
      ]
    },
    {
      "name": {
        "en": "Cauliflower",
        "ta": "பூக்கோஸ்",
        "hi": "फूलगोभी",
        "ml": "പൂക്കോസ്"
      },
      "image": "images/suppliments/cauliflower-veg.jpg",
      "prices": [
        34,
        26,
        21,
        41,
        10,
        13,
        36,
        13,
        28,
        23,
        21,
        33,
        45,
        32,
        31,
        16,
        29,
        21,
        48,
        29,
        34,
        16,
        33,
        45,
        20,
        48,
        45,
        31,
        17,
        26,
        38,
        10,
        17,
        36,
        39,
        26,
        18,
        35
      ]
    },
    {
      "name": {
        "en": "Coriander Leaves",
        "ta": "கொத்தமல்லி",
        "hi": "धनिया पत्ता",
        "ml": "മല്ലിയില"
      },
      "image": "images/suppliments/coriander-veg.jpg",
      "prices": [
        21,
        31,
        46,
        16,
        35,
        38,
        31,
        14,
        47,
        10,
        27,
        44,
        38,
        38,
        12,
        26,
        36,
        12,
        48,
        11,
        13,
        39,
        13,
        28,
        27,
        12,
        38,
        29,
        16,
        15,
        42,
        44,
        28,
        26,
        33,
        26,
        14,
        13
      ]
    },
    {
      "name": {
        "en": "Cucumber",
        "ta": "வெள்ளரிக்காய்",
        "hi": "खीरा",
        "ml": "വെള്ളരിക്ക"
      },
      "image": "images/suppliments/Cucumber-veg.jpg",
      "prices": [
        20,
        40,
        49,
        17,
        48,
        50,
        21,
        37,
        35,
        21,
        42,
        25,
        24,
        28,
        15,
        29,
        48,
        32,
        43,
        24,
        43,
        45,
        40,
        25,
        42,
        18,
        47,
        14,
        12,
        18,
        32,
        21,
        24,
        33,
        18,
        36,
        16,
        38
      ]
    },
    {
      "name": {
        "en": "Drumstick",
        "ta": "முருங்கைக்காய்",
        "hi": "सहजन",
        "ml": "മുരിങ്ങ"
      },
      "image": "images/suppliments/drumstick-veg.jpg",
      "prices": [
        15,
        50,
        35,
        29,
        32,
        50,
        28,
        38,
        27,
        30,
        37,
        43,
        23,
        22,
        29,
        18,
        19,
        25,
        11,
        25,
        31,
        41,
        20,
        10,
        13,
        16,
        47,
        27,
        48,
        25,
        11,
        25,
        31,
        47,
        16,
        44,
        45,
        22
      ]
    },
    {
      "name": {
        "en": "Ladies Finger",
        "ta": "வெண்டைக்காய்",
        "hi": "भिंडी",
        "ml": "വെണ്ടക്ക"
      },
      "image": "images/suppliments/okra-veg.jpg",
      "prices": [
        45,
        27,
        26,
        50,
        42,
        12,
        20,
        34,
        50,
        13,
        50,
        15,
        16,
        21,
        20,
        14,
        19,
        38,
        14,
        30,
        23,
        48,
        35,
        50,
        17,
        12,
        32,
        30,
        40,
        10,
        41,
        18,
        22,
        35,
        18,
        24,
        15,
        33
      ]
    },
    {
      "name": {
        "en": "Pumpkin",
        "ta": "பூசணிக்காய்",
        "hi": "कद्दू",
        "ml": "മത്തങ്ങ"
      },
      "image": "images/suppliments/pumpkin-veg.jpg",
      "prices": [
        48,
        50,
        43,
        24,
        48,
        22,
        40,
        45,
        49,
        15,
        12,
        10,
        42,
        27,
        18,
        33,
        18,
        44,
        25,
        35,
        11,
        24,
        12,
        45,
        22,
        14,
        40,
        28,
        35,
        27,
        16,
        49,
        21,
        27,
        46,
        28,
        23,
        45
      ]
    },
    {
      "name": {
        "en": "Radish",
        "ta": "முள்ளங்கி",
        "hi": "मूली",
        "ml": "മുല്ലങ്കി"
      },
      "image": "images/suppliments/radish-veg.jpg",
      "prices": [
        21,
        45,
        20,
        29,
        43,
        37,
        36,
        35,
        39,
        44,
        22,
        23,
        48,
        30,
        19,
        42,
        45,
        34,
        17,
        36,
        47,
        32,
        17,
        20,
        43,
        46,
        21,
        50,
        49,
        48,
        10,
        43,
        46,
        35,
        31,
        20,
        13,
        45
      ]
    },
    {
      "name": {
        "en": "Ridge Gourd",
        "ta": "பீர்க்கங்காய்",
        "hi": "तुरई",
        "ml": "പീർക്കങ്ങ"
      },
      "image": "images/suppliments/ridge-gourd-veg.jpg",
      "prices": [
        19,
        39,
        39,
        36,
        14,
        19,
        38,
        35,
        19,
        27,
        30,
        40,
        27,
        17,
        24,
        20,
        19,
        32,
        20,
        24,
        36,
        11,
        48,
        47,
        27,
        43,
        39,
        45,
        39,
        28,
        50,
        23,
        25,
        32,
        28,
        40,
        34,
        39
      ]
    },
    {
      "name": {
        "en": "Snake Gourd",
        "ta": "புடலங்காய்",
        "hi": "चिचिंडा",
        "ml": "പടവലങ്ങ"
      },
      "image": "images/suppliments/snake-gourd-veg.jpg",
      "prices": [
        17,
        44,
        16,
        16,
        37,
        21,
        22,
        17,
        49,
        45,
        30,
        32,
        48,
        48,
        42,
        42,
        20,
        28,
        43,
        12,
        39,
        29,
        37,
        23,
        33,
        35,
        41,
        44,
        27,
        27,
        25,
        26,
        29,
        50,
        21,
        33,
        29,
        37
      ]
    },
    {
      "name": {
        "en": "Turnip",
        "ta": "நவல் கிழங்கு",
        "hi": "शलगम",
        "ml": "ഷളഗം"
      },
      "image": "images/suppliments/turnip-veg.jpg",
      "prices": [
        24,
        37,
        17,
        23,
        47,
        13,
        34,
        13,
        36,
        36,
        15,
        47,
        13,
        17,
        47,
        42,
        49,
        26,
        14,
        32,
        47,
        42,
        28,
        44,
        28,
        22,
        50,
        14,
        36,
        10,
        32,
        48,
        23,
        32,
        18,
        46,
        45,
        21
      ]
    }
  ];

  final Map<String, Map<String, String>> _localizedStrings = {
    "market_prices": {
      "en": "Market Prices",
      "ta": "மார்க்கெட் விலை",
      "hi": "बाजार मूल्य",
      "ml": "മാർക്കറ്റ് വില"
    },
    "select_district": {
      "en": "Select District",
      "ta": "மாவட்டத்தைத் தேர்ந்தெடுக்கவும்",
      "hi": "जिला चुनें",
      "ml": "ജില്ല തിരഞ്ഞെടുക്കുക"
    },
    "more_details": {
      "en": "More Details",
      "ta": "மேலும் விவரங்கள்",
      "hi": "अधिक जानकारी",
      "ml": "കൂടുതൽ വിവരങ്ങൾ"
    }
  };

  int getDistrictIndex(String district) {
    return districts.indexOf(district);
  }

  void shuffleMarketData() {
    setState(() {
      marketData.shuffle(Random());
    });
  }

  void launchMarketDetails(String district) async {
    district = district.toLowerCase();
    final url = 'https://vegetablemarketprice.com/market/$district/today';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentLang = prefs.getString("locale") ?? "en";
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  @override
  Widget build(BuildContext context) {
    int districtIndex = getDistrictIndex(selectedDistrict);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 192, 255, 202),
        title: Text(
          _localizedStrings["market_prices"]?[_currentLang] ?? "Market Prices",
          style: const TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: LanguageSwitcher(
              onLocaleChange: (Locale newLocale) async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString("locale", newLocale.languageCode);
                setState(() {
                  _currentLang = newLocale.languageCode; // Update language code
                });
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonFormField<String>(
              value: selectedDistrict,
              decoration: InputDecoration(
                labelText: _localizedStrings["select_district"]
                        ?[_currentLang] ??
                    "Select District",
                border: const OutlineInputBorder(),
              ),
              items: districts.map((district) {
                return DropdownMenuItem(
                  value: district,
                  child: Text(
                    localizedDistricts[district]?[_currentLang] ?? district,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDistrict = value!;
                });
                shuffleMarketData();
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: marketData.length,
              itemBuilder: (context, index) {
                final item = marketData[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        item['image'].startsWith('http')
                            ? Image.network(
                                item['image'],
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                item['image'],
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'][_currentLang],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '₹${item['prices'][districtIndex]}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  launchMarketDetails(selectedDistrict),
                              child: Text(
                                _localizedStrings["more_details"]
                                        ?[_currentLang] ??
                                    "More Details",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
