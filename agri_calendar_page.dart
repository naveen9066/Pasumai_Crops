import 'package:crop_frontend/localization/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../widgets/language_switcher.dart';

class AgriCalendarPage extends StatefulWidget {
  final Function(Locale) onLocaleChange;
  const AgriCalendarPage({super.key, required this.onLocaleChange});

  @override
  State<AgriCalendarPage> createState() => _AgriCalendarPageState();
}

class _AgriCalendarPageState extends State<AgriCalendarPage> {
  // Localization of calendar data for different languages
  final Map<String, List<Map<String, dynamic>>> calendarData = const {
    'en': [
      {
        "month": "January",
        "cropsToSow": ["Maize", "Beans", "Tomato", "Green Chili"],
        "goodCrops": ["Groundnut", "Black Gram", "Green Gram"],
        "tasks": ["Preparing Cattle Feed", "Pest Control in Gardens"],
      },
      {
        "month": "February",
        "cropsToSow": ["Ladies Finger (Okra)", "Pumpkin", "Snake Gourd"],
        "goodCrops": ["Chickpeas", "Pigeon Peas"],
        "tasks": ["Fertilizer Application", "Preparation for Paddy Harvest"],
      },
      {
        "month": "March",
        "cropsToSow": ["Watermelon", "Musk Melon", "Ladies Finger"],
        "goodCrops": ["Coriander", "Drumstick"],
        "tasks": ["Harvesting Grains", "Crop Storage"],
      },
      {
        "month": "April",
        "cropsToSow": ["Sunflower", "Maize"],
        "goodCrops": ["Cucumber", "Snake Gourd"],
        "tasks": ["Land Preparation", "Maintenance of Farm Equipment"],
      },
      {
        "month": "May",
        "cropsToSow": ["Maize", "Samba Paddy Nursery"],
        "goodCrops": ["Masoor Dal (Red Lentils)", "Green Gram"],
        "tasks": ["Rainy Season Storage Preparation"],
      },
      {
        "month": "June",
        "cropsToSow": ["Paddy (Samba)", "Soybean", "Hibiscus"],
        "goodCrops": ["Various Vegetables"],
        "tasks": ["Paddy Transplantation", "Preventing Soil Erosion"],
      },
      {
        "month": "July",
        "cropsToSow": ["Paddy", "Corn", "Beans"],
        "goodCrops": ["Ash Gourd", "Ridge Gourd"],
        "tasks": ["Maintenance of Pulse Crops"],
      },
      {
        "month": "August",
        "cropsToSow": ["Green Gram", "Moong Dal", "Cluster Beans"],
        "goodCrops": ["Chickpeas", "Ladies Finger"],
        "tasks": ["Proper Irrigation"],
      },
      {
        "month": "September",
        "cropsToSow": ["Mid-season Paddy", "Pulses"],
        "goodCrops": ["Beans", "Ash Gourd"],
        "tasks": ["Weed Control", "Pest Management"],
      },
      {
        "month": "October",
        "cropsToSow": ["Millets", "Groundnut"],
        "goodCrops": ["Radish", "Carrot"],
        "tasks": ["Paddy Harvesting", "Crop Rotation"],
      },
      {
        "month": "November",
        "cropsToSow": ["Maize", "Groundnut", "Pulses"],
        "goodCrops": ["Green Chili", "Tomato"],
        "tasks": ["Monsoon Crop Maintenance"],
      },
      {
        "month": "December",
        "cropsToSow": ["Beetroot", "Carrot", "Onion"],
        "goodCrops": ["Varieties of Pulses"],
        "tasks": ["Winter Vegetable Care"],
      },
    ],
    'ta': [
      {
        "month": "ஜனவரி",
        "cropsToSow": ["மைசு", "பீன்ஸ்", "தக்காளி", "பச்சை மிளகு"],
        "goodCrops": ["நெல்", "பிளாக் கிராம்", "பச்சை கிராம்"],
        "tasks": ["கோழி உணவு தயாரித்தல்", "தோட்டங்களில் விரட்டல்"]
      },
      {
        "month": "பிப்ரவரி",
        "cropsToSow": ["உளர்க்கோழி (ஒக்ரா)", "பூசணி", "பாம்பு கப்ரி"],
        "goodCrops": ["சிக்கpeas", "பிட்ஜன் பீசு"],
        "tasks": ["காய்கறி உதவி", "பாடி கடற்கரைத்"]
      },
      {
        "month": "மார்ச்",
        "cropsToSow": ["வாட்டர்மெலன்", "மஸ்க் மெல்லன்", "உளர்க்கோழி"],
        "goodCrops": ["கொத்தமல்லி", "மரச்சி"],
        "tasks": ["விதைகள் அறுவடை", "பயிர் சேமிப்பு"]
      },
      {
        "month": "ஏப்ரல்",
        "cropsToSow": ["சூரியகாந்தி", "மைசு"],
        "goodCrops": ["குக்கும்பர்", "பாம்பு கப்ரி"],
        "tasks": ["நில தயார் செய்", "பரிதாபங்கள் பராமரிப்பு"]
      },
      {
        "month": "மே",
        "cropsToSow": ["மைசு", "சாம்பா பாட்டு நர்சரி"],
        "goodCrops": ["மசூர் பருப்பு (சிவப்பு பருப்பு)", "பச்சை கிராம்"],
        "tasks": ["மழைக்கால உபகரணங்கள் தயார் செய்"]
      },
      {
        "month": "ஜூன்",
        "cropsToSow": ["பாடி (சாம்பா)", "சோயாபீன்", "ஹிபிசஸ்"],
        "goodCrops": ["பல்வேறு காய்கறிகள்"],
        "tasks": ["பாடி செடிகள் காடு", "மண் குன்றியதைத் தவிர்க்கவும்"]
      },
      {
        "month": "ஜூலை",
        "cropsToSow": ["பாடி", "பக்கோறி", "பீன்ஸ்"],
        "goodCrops": ["அஷ் கவுசு", "ரிட்ஜ் கவுசு"],
        "tasks": ["புல் பயிர் பராமரிப்பு"]
      },
      {
        "month": "ஆகஸ்ட்",
        "cropsToSow": ["பச்சை கிராம்", "மூங்கூா் பருப்பு", "கிளஸ்டர் பருப்பு"],
        "goodCrops": ["சிக்கpeas", "உளர்க்கோழி"],
        "tasks": ["சரியான நீர் வினாடி"]
      },
      {
        "month": "செப்டம்பர்",
        "cropsToSow": ["நடுத்தர பருவம் பாடி", "பருப்பு"],
        "goodCrops": ["பீன்ஸ்", "அஷ் கவுசு"],
        "tasks": ["புல் கட்டுப்பாடு", "விரட்டல் முகாம்கள்"]
      },
      {
        "month": "அக்டோபர்",
        "cropsToSow": ["மில்லெட்ஸ்", "நெல்"],
        "goodCrops": ["மூலிகை", "கேரட்"],
        "tasks": ["பாடி அறுவடை", "பயிர் திருப்புதல்"]
      },
      {
        "month": "நவம்பர்",
        "cropsToSow": ["மைசு", "நெல்", "பருப்பு"],
        "goodCrops": ["பச்சை மிளகு", "தக்காளி"],
        "tasks": ["மழைக்கால பயிர் பராமரிப்பு"]
      },
      {
        "month": "திசம்பர்",
        "cropsToSow": ["பீட்ரூட்", "கேரட்", "பெருங்"],
        "goodCrops": ["பருப்புகளின் வகைகள்"],
        "tasks": ["குளிர் காய்கறி பராமரிப்பு"]
      }
    ],
    "hi": [
      {
        "month": "जनवरी",
        "cropsToSow": ["मक्का", "बीन्स", "टमाटर", "हरी मिर्च"],
        "goodCrops": ["मूंगफली", "काले चने", "हरी मटर"],
        "tasks": ["पशु आहार तैयार करना", "बगानों में कीट नियंत्रण"]
      },
      {
        "month": "फरवरी",
        "cropsToSow": ["भिंडी (ओकरा)", "कद्दू", "सांप लौकी"],
        "goodCrops": ["चिकपीस", "पिड्जन पीस"],
        "tasks": ["उर्वरक का आवेदन", "धान की फसल की तैयारी"]
      },
      {
        "month": "मार्च",
        "cropsToSow": ["तरबूज", "मस्क मेलन", "भिंडी"],
        "goodCrops": ["धनिया", "मोरिंगा"],
        "tasks": ["अनाज की कटाई", "फसल संग्रहण"]
      },
      {
        "month": "अप्रैल",
        "cropsToSow": ["सूरजमुखी", "मक्का"],
        "goodCrops": ["खीरा", "सांप लौकी"],
        "tasks": ["भूमि की तैयारी", "कृषि उपकरणों की देखभाल"]
      },
      {
        "month": "मई",
        "cropsToSow": ["मक्का", "सांबा धान नर्सरी"],
        "goodCrops": ["मसूर दाल (लाल दाल)", "हरी मटर"],
        "tasks": ["बरसात के मौसम की फसल संग्रहण तैयारी"]
      },
      {
        "month": "जून",
        "cropsToSow": ["धान (सांबा)", "सोयाबीन", "हिबिस्कस"],
        "goodCrops": ["विविध सब्जियाँ"],
        "tasks": ["धान की रोपाई", "मिट्टी के कटाव को रोकना"]
      },
      {
        "month": "जुलाई",
        "cropsToSow": ["धान", "मक्का", "बीन्स"],
        "goodCrops": ["अश गोरड", "रिज गोरड"],
        "tasks": ["पल्स की फसलों की देखभाल"]
      },
      {
        "month": "अगस्त",
        "cropsToSow": ["हरी मटर", "मूंग दाल", "क्लस्टर बीन्स"],
        "goodCrops": ["चिकपीस", "भिंडी"],
        "tasks": ["सही सिंचाई"]
      },
      {
        "month": "सितंबर",
        "cropsToSow": ["मध्य-सीजन धान", "दालें"],
        "goodCrops": ["बीन्स", "अश गोरड"],
        "tasks": ["घास की सफाई", "कीट प्रबंधन"]
      },
      {
        "month": "अक्टूबर",
        "cropsToSow": ["मिलेट्स", "मक्का"],
        "goodCrops": ["मूली", "गाजर"],
        "tasks": ["धान की कटाई", "फसल रोटेशन"]
      },
      {
        "month": "नवंबर",
        "cropsToSow": ["मक्का", "मूंगफली", "दालें"],
        "goodCrops": ["हरी मिर्च", "टमाटर"],
        "tasks": ["मानसून की फसल की देखभाल"]
      },
      {
        "month": "दिसंबर",
        "cropsToSow": ["चुकंदर", "गाजर", "प्याज"],
        "goodCrops": ["दालों की किस्में"],
        "tasks": ["सर्दियों की सब्जियों की देखभाल"]
      }
    ],
    'ml': [
      {
        "month": "ജനുവരി",
        "cropsToSow": ["മക്ക", "പയർ", "തക്കാളി", "പച്ചമുളക്"],
        "goodCrops": ["മുതിർന്ന എണ്ണ", "പച്ചപയർ", "പച്ചപയർ"],
        "tasks": ["പശു ഭക്ഷണം ഒരുക്കുക", "പests കൃഷി"],
      },
      {
        "month": "ഫെബ്രുവരി",
        "cropsToSow": ["ഭിണ്ഡി (ഒക്ര)", "കൂട്ട്", "പാമ്പ് കോഴി"],
        "goodCrops": ["ചിക്കപീസ്", "പിജൻ പീസ്"],
        "tasks": ["ഉറുക്ക് പ്രയോഗം", "പാടിപണി മണ്ണ്"],
      },
      {
        "month": "മാർച്ച്",
        "cropsToSow": ["വാട്ടർമെലൺ", "മസ്ക് മേളൻ", "ഭിണ്ഡി"],
        "goodCrops": ["കൊറിയാണ്ടർ", "ഡ്രംസ്റ്റിക്ക്"],
        "tasks": ["അഴുക്കു വിത്തുകൾ", "അപ്പൊക്കായുള്ള"],
      },
      {
        "month": "ഏപ്രിൽ",
        "cropsToSow": ["സൺഫ്ലവർ", "മക്ക"],
        "goodCrops": ["കുക്കുംബർ", "പാമ്പിന്റെ കോഴി"],
        "tasks": ["ഭാരവഹിതാവിന്, പ്രണതങ്ങൾ"],
      },
      {
        "month": "മെയ്",
        "cropsToSow": ["മക്ക", "സാംബ പാടത്തിന്റെ സെയിൽ"],
        "goodCrops": ["മസൂർ ഡാൽ (പെരു തോരൻ)", "പച്ചപയർ"],
        "tasks": ["പെയ്ത്ത കാല സംഭരണം"],
      },
      {
        "month": "ജൂൺ",
        "cropsToSow": ["പാടി (സാംബ)", "സോയാബീൻ", "ഹിബിസ്കസ്"],
        "goodCrops": ["വിവിധ പച്ചക്കറികൾ"],
        "tasks": ["പാടിയിൽ പ്രവേശന പാടത്തിലേക്ക്"],
      },
      {
        "month": "ജൂലൈ",
        "cropsToSow": ["പാടി", "മക്ക", "പയർ"],
        "goodCrops": ["ആഷ് ഗോർഡ്", "റിഡ്ജ് ഗോർഡ്"],
        "tasks": ["പഴങ്കച്ച", "അംഗ്ഗ്രിജ ലിഖിത"],
      },
      {
        "month": "ആഗസ്റ്റ്",
        "cropsToSow": ["പച്ചപയർ", "മൂംഗ് ഡാൽ", "ക്ലസ്റ്റർബീൻസ്"],
        "goodCrops": ["ചിക്കപീസ്", "ഭിണ്ഡി"],
        "tasks": ["പാരമ്പര്യ ജൈവചേരിതമായ"],
      },
      {
        "month": "സെപ്റ്റംബർ",
        "cropsToSow": ["പാറ്റി പരിണമിക്കാൻ", "പശുപോഷണ"],
        "goodCrops": ["ബീൻസ്", "ആഷ് ഗോർഡ്"],
        "tasks": ["പുത്തിരി ദുരിത ചോക്ലെയിമുഖം"],
      },
      {
        "month": "ഒക്ടോബർ",
        "cropsToSow": ["മില്ലറ്റ്സ്", "മുതിർന്ന പിൻകണ്ണങ്ങൾ"],
        "goodCrops": ["പാടില്ലായി", "പച്ചുപേരു"],
        "tasks": ["പാടിൽ പോക്കറ്റിന്റെ തിരഞ്ഞെടുക്കല്"],
      },
      {
        "month": "നവംബർ",
        "cropsToSow": ["മക്ക", "പയർ", "പുസ്സൽ"],
        "goodCrops": ["പച്ചമുളക്", "തക്കാളി"],
        "tasks": ["മോണ്സൂൺ പോക്കിളിൽ സമാധാനം"],
      },
      {
        "month": "ഡിസംബർ",
        "cropsToSow": ["ബീറ്റ് ரூട്ട്", "കാർട്ട്", "ഉണക്കിയ പച്ചക്കറി"],
        "goodCrops": ["പല പഞ്ഞി മൂലക്കെടുക"],
        "tasks": ["ചൂടു കാല കൃഷി സന്ദർശനം"]
      },
    ]
  };
  final Map<String, Map<String, String>> localizedTitles = {
    'en': {
      "agriCalendar": "Agri Calendar",
      "cropsToSow": "Crops to Sow",
      "goodCrops": "Good Crops",
      "tasks": "Tasks"
    },
    'ta': {
      "agriCalendar": "விவசாய நாட்காட்டி",
      "cropsToSow": "வேலைகளுக்கு விதைகள் போடுதல்",
      "goodCrops": "நல்ல பயிர்கள்",
      "tasks": "பணிகள்"
    },
    'hi': {
      "agriCalendar": "कृषि कैलेंडर",
      "cropsToSow": "उगाने के लिए फसलें",
      "goodCrops": "अच्छी फसलें",
      "tasks": "कार्य"
    },
    'ml': {
      "agriCalendar": "കൃഷി കലണ്ടർ",
      "cropsToSow": "വിതയ്ക്കാനുള്ള പച്ചക്കറികൾ",
      "goodCrops": "ചെറിയ വിളകൾ",
      "tasks": "പ്രവൃത്തികൾ"
    }
  };

  // Fetch the correct titles based on the current locale
  List<Map<String, dynamic>> getCalendarData(Locale locale) {
    final languageCode = locale.languageCode;
    final localizedStrings =
        localizedTitles[languageCode] ?? localizedTitles['en']!;
    return calendarData[languageCode] ?? calendarData['en']!;
  }

  Widget _buildListSection(String title, List<String> items, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title:",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        ...items.map(
          (item) => Row(
            children: [
              Icon(icon, size: 16, color: Colors.green[700]),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the current locale
    final locale = Localizations.localeOf(context);
    final data = getCalendarData(locale);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 192, 255, 202),
        title: Text(
          AppLocalizations.of(context)!.translate('agri_calendar'),
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: LanguageSwitcher(onLocaleChange: widget.onLocaleChange),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final month = data[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                month["month"],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildListSection(
                        localizedTitles[locale.languageCode]?['cropsToSow'] ??
                            "Crops to Sow",
                        List<String>.from(month["cropsToSow"]),
                        Icons.agriculture,
                      ),
                      _buildListSection(
                        localizedTitles[locale.languageCode]?['goodCrops'] ??
                            "Good Crops",
                        List<String>.from(month["goodCrops"]),
                        Icons.eco,
                      ),
                      _buildListSection(
                        localizedTitles[locale.languageCode]?['tasks'] ??
                            "Tasks",
                        List<String>.from(month["tasks"]),
                        Icons.task,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
