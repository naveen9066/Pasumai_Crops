import 'package:crop_frontend/widgets/language_switcher.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BirdsAlertPage extends StatefulWidget {
  final Function(Locale) onLocaleChange;
  const BirdsAlertPage({super.key, required this.onLocaleChange});

  @override
  State<BirdsAlertPage> createState() => _BirdsAlertPageState();
}

class _BirdsAlertPageState extends State<BirdsAlertPage> {
  String _currentLang = "en";

  final List<Map<String, dynamic>> birds = [
    {
      "name": {
        "en": "Sparrow",
        "ta": "சிட்டுக்குருவி",
        "hi": "गौरैया",
        "ml": "ചിറക്"
      },
      "image": "images/birds/sparrow.jpeg",
      "description": {
        "en": "Helpful - Eats insects and helps in pest control.",
        "ta":
            "உதவிகரமானது - பூச்சிகளைத் தின்கிறது மற்றும் கட்டுப்படுத்த உதவுகிறது.",
        "hi": "सहायक - कीड़े खाता है और कीट नियंत्रण में मदद करता है।",
        "ml":
            "ഉപകാരപ്പെടുന്നത് - കീടങ്ങളെ തിന്നുകയും നിയന്ത്രിക്കാനും സഹായിക്കുന്നു."
      }
    },
    {
      "name": {"en": "Crow", "ta": "காகம்", "hi": "कौआ", "ml": "കാക്ക"},
      "image": "images/birds/crow.jpeg",
      "description": {
        "en": "Harmful - Can damage crops and feed on seeds and saplings.",
        "ta":
            "தீங்கு விளைவிக்கக்கூடியது - பயிர்கள் மற்றும் விதைகள் மீது தாக்கம் செய்கிறது.",
        "hi": "हानिकारक - फसलों को नुकसान पहुंचा सकता है और बीज खा सकता है।",
        "ml": "ഹാനികരം - വിളകൾക്ക് കേടുവരുത്തുകയും വിത്തുകൾ തിന്നുകയും ചെയ്യാം."
      }
    },
    {
      "name": {"en": "Peacock", "ta": "மயில்", "hi": "मोर", "ml": "മയിലൻ"},
      "image": "images/birds/peacock.jpeg",
      "description": {
        "en":
            "Helpful - Eats insects and snakes, a natural predator in the field.",
        "ta":
            "உதவிகரமானது - பூச்சிகள் மற்றும் பாம்புகளை உண்ணுகிறது, பசுமை வயலின் பாதுகாவலர்.",
        "hi": "सहायक - कीड़े और सांप खाता है, खेत में एक प्राकृतिक शिकारी।",
        "ml":
            "ഉപകാരപ്പെടുന്നത് - കീടങ്ങളും പാമ്പുകളും തിന്നുന്നു, വയലുകളുടെ സ്വാഭാവിക തിന്നുകാരൻ."
      }
    },
    {
      "name": {"en": "Pigeon", "ta": "புறா", "hi": "कबूतर", "ml": "പാര"},
      "image": "images/birds/pigeon.jpeg",
      "description": {
        "en": "Neutral - Mostly harmless, but can eat stored grains.",
        "ta":
            "நடுநிலை - பெரும்பாலும் தீங்கு விளைவிக்காது, ஆனால் சேமித்திருந்ததைக் கொண்டுவிடும்.",
        "hi": "तटस्थ - ज्यादातर हानिरहित, लेकिन संग्रहीत अनाज खा सकते हैं।",
        "ml": "തടവില്ലാത്തത് - കേടുവരുത്തില്ലെങ്കിലും സംഭരിച്ച ധാന്യം തിന്നാം."
      }
    },
    {
      "name": {"en": "Myna", "ta": "மைனா", "hi": "मैना", "ml": "മൈന"},
      "image": "images/birds/myna.jpeg",
      "description": {
        "en": "Helpful - Controls insects and pests in agricultural areas.",
        "ta":
            "உதவிகரமானது - வேளாண்மை நிலங்களில் பூச்சிகளை கட்டுப்படுத்துகிறது.",
        "hi": "सहायक - कृषि क्षेत्रों में कीटों को नियंत्रित करता है।",
        "ml": "ഉപകാരപ്പെടുന്നത് - കൃഷിയിടങ്ങളിൽ കീടങ്ങളെ നിയന്ത്രിക്കുന്നു."
      }
    },
    {
      "name": {"en": "Parrot", "ta": "கிளி", "hi": "तोता", "ml": "തത്ത"},
      "image": "images/birds/parrot.jpeg",
      "description": {
        "en":
            "Harmful - Can damage fruit crops like guava, mango, and pomegranate.",
        "ta":
            "தீங்கு விளைவிக்கக்கூடியது - கொய்யா, மாம்பழம், மாதுளை போன்ற பழவகைகளை சேதப்படுத்துகிறது.",
        "hi":
            "हानिकारक - अमरूद, आम और अनार जैसे फलों की फसलों को नुकसान पहुंचा सकता है।",
        "ml": "ഹാനികരം - പെരുക്ക, മാങ്ങ, മാതളനാരങ്ങ തുടങ്ങിയ ഫലങ്ങൾ തിന്നുന്നു."
      }
    },
    {
      "name": {
        "en": "Kingfisher",
        "ta": "மீன்பிடி பறவை",
        "hi": "किंगफिशर",
        "ml": "മീനൊറ്റപ്പക്ഷി"
      },
      "image": "images/birds/kingfisher.jpeg",
      "description": {
        "en": "Helpful - Mainly fish-eaters, no crop harm.",
        "ta":
            "உதவிகரமானது - மீன்களை மட்டுமே உண்ணுகிறது, பயிர்களுக்கு பாதிப்பு இல்லை.",
        "hi": "सहायक - मछलियों को खाता है, फसलों को नुकसान नहीं पहुंचाता।",
        "ml":
            "ഉപകാരപ്പെടുന്നത് - മീനുകളെ മാത്രമേ തിന്നുകയുള്ളൂ, വിളകൾക്ക് അപകടമില്ല."
      }
    },
    {
      "name": {
        "en": "Drongo",
        "ta": "கருங்குயில்",
        "hi": "ड्रोंगो",
        "ml": "കരിങ്കിളി"
      },
      "image": "images/birds/drongo-bird.jpeg",
      "description": {
        "en": "Helpful - Eats pests and insects, protecting crops naturally.",
        "ta":
            "உதவிகரமானது - பூச்சிகளை உண்பதால் பயிர்களுக்கு பாதுகாப்பாக இருக்கிறது.",
        "hi": "सहायक - कीटों को खाता है, जिससे फसलों की रक्षा होती है।",
        "ml":
            "ഉപകാരപ്പെടുന്നത് - കീടങ്ങളെ തിന്നുകയും വിളകളെ സംരക്ഷിക്കുകയും ചെയ്യുന്നു."
      }
    },
    {
      "name": {
        "en": "Egret",
        "ta": "சின்னக் கொக்கு",
        "hi": "बगुला",
        "ml": "കൊച്ചു കോഴി"
      },
      "image": "images/birds/egret.jpeg",
      "description": {
        "en":
            "Helpful - Feeds on insects from fields, especially during ploughing.",
        "ta": "உதவிகரமானது - இழுவை வேலையின் போது பூச்சிகளை உண்ணும்.",
        "hi": "सहायक - खेतों से कीड़े खाता है, विशेष रूप से जुताई के समय।",
        "ml":
            "ഉപകാരപ്പെടുന്നത് - വയലുകളിൽ നിന്ന് കീടങ്ങൾ തിന്നുന്നു, പ്രത്യേകിച്ച് ഉഴുത സമയത്ത്."
      }
    },
    {
      "name": {
        "en": "Indian Roller",
        "ta": "பனங்காடை",
        "hi": "नीलकंठ",
        "ml": "ഇന്ത്യൻ റോളർ"
      },
      "image": "images/birds/indian-roller.jpg",
      "description": {
        "en": "Helpful - Feeds on harmful insects and small reptiles.",
        "ta":
            "உதவிகரமானது - தீங்கு தரும் பூச்சிகள் மற்றும் சிறிய பாம்புகளை உண்கிறது.",
        "hi": "सहायक - हानिकारक कीटों और छोटे सरीसृपों को खाता है।",
        "ml":
            "ഉപകാരപ്പെടുന്നത് - ഹാനികരമായ കീടങ്ങളും ചെറിയ പതിപ്പുകളും തിന്നുന്നു."
      }
    },
    {
      "name": {
        "en": "Cattle Egret",
        "ta": "மாடுக்கொக்கு",
        "hi": "गाय बगुला",
        "ml": "പശു കൊക്ക്"
      },
      "image": "images/birds/cattle-egret.jpeg",
      "description": {
        "en":
            "Helpful - Follows cattle to eat insects disturbed by their movement.",
        "ta":
            "உதவிகரமானது - மாடுகளுடன் சென்று அவற்றால் கிளறப்படும் பூச்சிகளை உண்ணும்.",
        "hi":
            "सहायक - मवेशियों के साथ चलकर कीड़े खाता है जो उनकी गतिविधि से बाहर आते हैं।",
        "ml":
            "ഉപകാരപ്പെടുന്നത് - പശുക്കളെ പിന്തുടർന്ന് അവ കുഴയ്ക്കുന്ന കീടങ്ങളെ തിന്നുന്നു."
      }
    },
    {
      "name": {
        "en": "Lapwing",
        "ta": "வான்கொக்கு",
        "hi": "टिटहरी",
        "ml": "തട്ടിക്കുരുവി"
      },
      "image": "images/birds/lapwing.jpeg",
      "description": {
        "en": "Helpful - Eats insects from fields and helps reduce pests.",
        "ta": "உதவிகரமானது - வயல்களில் பூச்சிகளை உண்ணி கிழக்குகளை குறைக்கும்.",
        "hi": "सहायक - खेतों से कीट खाकर कीटों की संख्या को कम करता है।",
        "ml":
            "ഉപകാരപ്പെടുന്നത് - വയലുകളിൽ നിന്ന് കീടങ്ങൾ തിന്നുകയും അതിനാൽ കീട നിയന്ത്രണം നടക്കുന്നു."
      }
    },
    {
      "name": {
        "en": "Common Hoopoe",
        "ta": "சின்ன கோழி",
        "hi": "हुदहुद",
        "ml": "പെരുന്തന്‍ കിളി"
      },
      "image": "images/birds/hoopoe.jpg",
      "description": {
        "en": "Helpful - Feeds on larvae and beetles found in soil.",
        "ta":
            "உதவிகரமானது - மண்ணில் உள்ள புழுக்கள் மற்றும் கரப்பான்களை உண்கிறது.",
        "hi": "सहायक - मिट्टी में पाए जाने वाले कीड़ों और लार्वा को खाता है।",
        "ml":
            "ഉപകാരപ്പെടുന്നത് - മണ്ണിൽ കാണുന്ന പുഴുക്കളെയും ചെറു കീടങ്ങളെയും തിന്നുന്നു."
      }
    },
    {
      "name": {
        "en": "Black Kite",
        "ta": "கருங்கழுகு",
        "hi": "काली चील",
        "ml": "കറുത്ത പരുന്ത്"
      },
      "image": "images/birds/balck-kite.jpeg",
      "description": {
        "en":
            "Helpful - Scavenger bird that helps clean dead animals near farms.",
        "ta":
            "உதவிகரமானது - மரித்த விலங்குகளை சாப்பிட்டு விவசாய நிலங்களை சுத்தமாக வைத்திருக்கிறது.",
        "hi":
            "सहायक - खेतों के पास मरे हुए जानवरों को खाकर सफाई में मदद करता है।",
        "ml":
            "ഉപകാരപ്പെടുന്നത് - ഫാമിനടുത്തുള്ള ശവങ്ങൾ തിന്ന് ശുചിത്വം നിലനിർത്തുന്നു."
      }
    },
    {
      "name": {
        "en": "Barn Owl",
        "ta": "வளங்குருவி",
        "hi": "उल्लू",
        "ml": "അള്ളിലാക്കുള്ളി"
      },
      "image": "images/birds/owl.jpg",
      "description": {
        "en": "Helpful - Controls rodent population in fields at night.",
        "ta":
            "உதவிகரமானது - இரவில் வயல்களில் எலிகளை வேட்டையாடி கட்டுப்படுத்துகிறது.",
        "hi":
            "सहायक - रात को खेतों में चूहों को खाकर उनकी संख्या नियंत्रित करता है।",
        "ml":
            "ഉപകാരപ്പെടുന്നത് - രാത്രിയിൽ വയലുകളിൽ എലികളെ പിടിച്ച് നിയന്ത്രിക്കുന്നു."
      }
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentLang = prefs.getString("locale") ?? "en";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getLocalizedTitle()),
        backgroundColor: Color.fromARGB(255, 192, 255, 202),
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
      body: ListView.builder(
        itemCount: birds.length,
        itemBuilder: (context, index) {
          final bird = birds[index];
          final name = bird["name"][_currentLang] ?? bird["name"]["en"];
          final description =
              bird["description"][_currentLang] ?? bird["description"]["en"];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _buildImage(bird["image"]),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    if (imagePath.startsWith("http")) {
      return Image.network(
        imagePath,
        height: 100,
        width: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image),
      );
    } else {
      return Image.asset(
        imagePath,
        height: 100,
        width: 100,
        fit: BoxFit.cover,
      );
    }
  }

  String _getLocalizedTitle() {
    switch (_currentLang) {
      case "ta":
        return "பறவை எச்சரிக்கை";
      case "hi":
        return "पक्षी चेतावनी";
      case "ml":
        return "പക്ഷി മുന്നറിയിപ്പുകൾ";
      default:
        return "Bird Alerts";
    }
  }
}
