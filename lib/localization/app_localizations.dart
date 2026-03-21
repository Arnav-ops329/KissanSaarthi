import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      "app_title": "KisaanSaarthi",
      "smart_farmer_ai": "SMART FARMER AI",
      "ai_powered": "AI-powered",
      "monitoring_health": "Monitoring your field's health",
      "partly_cloudy": "Partly Cloudy",
      "humidity": "Humidity",
      "smart_tip": "SMART TIP",
      "weather_note_home": "Perfect weather for nitrogen application today.",
      "scan_crop": "Scan Crop",
      "scan_crop_desc": "Identify pests and diseases instantly using AI.",
      "upload_image": "Upload Image",
      "upload_image_desc": "Analyze previously taken photos from your gallery.",
      "mandi_prices": "Mandi Prices",
      "mandi_prices_desc": "Real-time market rates and trend analysis.",
      "fertilizer": "Fertilizer",
      "fertilizer_desc": "Nutrition plans and fertilizer calculators.",
      "crop_suggest": "Crop Suggest",
      "crop_suggest_desc": "Smart recommendations based on your soil.",
      "select_language": "Select Language",
      "english": "English",
      "hindi": "हिंदी",
      "point_at_crop": "Point at crop for live ID",
      "diagnosis_result": "Diagnosis Result",
      "selected_crop": "Selected Crop",
      "detected_disease": "Detected Disease",
      "ai_confidence": "AI Confidence",
      "ai_agronomist_advice": "AI Agronomist Advice",
      "scan_another_crop": "SCAN ANOTHER CROP",
      "calculating": "Calculating...",
      "fertilizer_calculator": "Fertilizer Calculator",
      "select_crop": "Select Crop",
      "soil_type": "Soil Type",
      "weather": "Weather",
      "land_area": "Land Area (in acres)",
      "calculation_result": "Calculation Result",
      "verified_agri_advice": "Verified Agri Advice",
      "wheat": "Wheat",
      "rice": "Rice",
      "potato": "Potato",
      "tomato": "Tomato",
      "alluvial": "Alluvial",
      "black": "Black",
      "sandy": "Sandy",
      "normal": "Normal",
      "dry": "Dry",
      "rainy": "Rainy"
    },
    'hi': {
      "app_title": "किसान सारथी",
      "smart_farmer_ai": "स्मार्ट किसान एआई",
      "ai_powered": "एआई द्वारा संचालित",
      "monitoring_health": "आपके खेत की निगरानी",
      "partly_cloudy": "आंशिक रूप से बादल",
      "humidity": "नमी",
      "smart_tip": "स्मार्ट टिप",
      "weather_note_home": "आज नाइट्रोजन डालने के लिए सही मौसम है।",
      "scan_crop": "फसल स्कैन करें",
      "scan_crop_desc": "एआई का उपयोग करके कीटों और बीमारियों की तुरंत पहचान करें।",
      "upload_image": "फोटो अपलोड करें",
      "upload_image_desc": "अपनी गैलरी से पुरानी फोटो का विश्लेषण करें।",
      "mandi_prices": "मंडी भाव",
      "mandi_prices_desc": "वास्तविक समय के बाजार भाव और विश्लेषण।",
      "fertilizer": "उर्वरक (खाद)",
      "fertilizer_desc": "पोषण योजना और उर्वरक कैलकुलेटर।",
      "crop_suggest": "फसल सुझाव",
      "crop_suggest_desc": "आपकी मिट्टी के आधार पर सही फसल का सुझाव।",
      "select_language": "भाषा चुनें",
      "english": "English",
      "hindi": "हिंदी",
      "point_at_crop": "लाइव स्कैनिंग के लिए फसल पर कैमरा लगाएं",
      "diagnosis_result": "निदान परिणाम",
      "selected_crop": "चुनी गई फसल",
      "detected_disease": "पता चली बीमारी",
      "ai_confidence": "एआई सटीकता",
      "ai_agronomist_advice": "एआई कृषि विशेषज्ञ सलाह",
      "scan_another_crop": "दूसरी फसल स्कैन करें",
      "calculating": "गणना हो रही है...",
      "fertilizer_calculator": "खाद कैलकुलेटर",
      "select_crop": "फसल चुनें",
      "soil_type": "मिट्टी का प्रकार",
      "weather": "मौसम",
      "land_area": "भूमि क्षेत्र (एकड़ में)",
      "calculation_result": "गणना का परिणाम",
      "verified_agri_advice": "सत्यापित कृषि सलाह",
      "wheat": "गेहूँ",
      "rice": "चावल",
      "potato": "आलू",
      "tomato": "टमाटर",
      "alluvial": "जलोढ़",
      "black": "काली",
      "sandy": "रेतीली",
      "normal": "सामान्य",
      "dry": "सूखा",
      "rainy": "बरसात"
    },
    'mr': {
      "app_title": "डिजिटल ॲग्रोनॉमिस्ट",
      "smart_farmer_ai": "फार्मिंग हब",
      "ai_powered": "प्रिसिजन",
      "monitoring_health": "तुमच्या शेताच्या आरोग्याचे रिअल-टाइम मॉनिटरिंग",
      "partly_cloudy": "अंशतः ढगाळ",
      "humidity": "आर्द्रता",
      "smart_tip": "स्मार्ट टीप",
      "weather_note_home": "नायट्रोजन खत देण्यासाठी आजचे हवामान योग्य आहे.",
      "scan_crop": "पीक स्कॅन करा",
      "scan_crop_desc": "एआय (AI) चा वापर करून कीटक आणि रोगांची त्वरित ओळख करा.",
      "upload_image": "फोटो अपलोड करा",
      "upload_image_desc": "तुमच्या गॅलरीमधील जुने फोटो तपासा.",
      "mandi_prices": "बाजारभाव",
      "mandi_prices_desc": "रिअल-टाइम मार्केट रेट आणि कल विश्लेषण.",
      "fertilizer": "खते (Fertilizer)",
      "fertilizer_desc": "पोषण योजना आणि खत कॅल्क्युलेटर.",
      "crop_suggest": "पीक सुचवा",
      "crop_suggest_desc": "तुमच्या मातीच्या आधारे योग्य पिकाचा सल्ला.",
      "select_language": "भाषा निवडा",
      "english": "English",
      "hindi": "हिंदी",
      "point_at_crop": "लाइव्ह आयडीसाठी पिकाकडे कॅमेरा धरा",
      "diagnosis_result": "निदान परिणाम",
      "selected_crop": "निवडलेले पीक",
      "detected_disease": "आढळलेला आजार",
      "ai_confidence": "एआय खात्री (AI Confidence)",
      "ai_agronomist_advice": "एआय कृषी तज्ञाचा सल्ला",
      "scan_another_crop": "दुसरे पीक स्कॅन करा",
      "calculating": "गणना करत आहे...",
      "fertilizer_calculator": "खत कॅल्क्युलेटर",
      "select_crop": "पीक निवडा",
      "soil_type": "मातीचा प्रकार",
      "weather": "हवामान",
      "land_area": "जमिनीचे क्षेत्रफळ (एकरमध्ये)",
      "calculation_result": "गणनेचा निकाल",
      "verified_agri_advice": "प्रमाणित कृषी सल्ला",
      "wheat": "गहू",
      "rice": "तांदूळ",
      "potato": "बटाटा",
      "tomato": "टोमॅटो",
      "alluvial": "गाळाची",
      "black": "काळी",
      "sandy": "वाळूची",
      "normal": "सामान्य",
      "dry": "कोरडे",
      "rainy": "पावसाळी"
    },
    'bn': {
      "app_title": "ডিজিটাল এগ্রোনোমিস্ট",
      "smart_farmer_ai": "ফার্মিং হাব",
      "ai_powered": "প্রিসিশন",
      "monitoring_health": "আপনার ক্ষেতের স্বাস্থ্যের রিয়েল-টাইম মনিটরিং",
      "partly_cloudy": "আংশিক মেঘলা",
      "humidity": "আর্দ্রতা",
      "smart_tip": "স্মার্ট টিপ",
      "weather_note_home": "আজ নাইট্রোজেন প্রয়োগের জন্য উপযুক্ত আবহাওয়া।",
      "scan_crop": "ফসল স্ক্যান করুন",
      "scan_crop_desc": "এআই (AI) ব্যবহার করে তাত্ক্ষণিকভাবে কীটপতঙ্গ এবং রোগ শনাক্ত করুন।",
      "upload_image": "ছবি আপলোড করুন",
      "upload_image_desc": "আপনার গ্যালারির পুরানো ছবি বিশ্লেষণ করুন।",
      "mandi_prices": "মান্ডির দাম",
      "mandi_prices_desc": "রিয়েল-টাইম মার্কেট রেট এবং ট্রেন্ড বিশ্লেষণ।",
      "fertilizer": "সার (Fertilizer)",
      "fertilizer_desc": "পুষ্টি পরিকল্পনা এবং সার ক্যালকুলেটর।",
      "crop_suggest": "ফসল পরামর্শ",
      "crop_suggest_desc": "আপনার মাটির ওপর ভিত্তি করে সঠিক পরামর্শ।",
      "select_language": "ভাষা নির্বাচন করুন",
      "english": "English",
      "hindi": "हिंदी",
      "point_at_crop": "লাইভ আইডির জন্য ফসলের দিকে ক্যামেরা ধরুন",
      "diagnosis_result": "রোগ নির্ণয়ের ফলাফল",
      "selected_crop": "নির্বাচিত ফসল",
      "detected_disease": "শনাক্তকৃত রোগ",
      "ai_confidence": "এআই আত্মবিশ্বাস",
      "ai_agronomist_advice": "এআই কৃষিবিদের পরামর্শ",
      "scan_another_crop": "অন্য ফসল স্ক্যান করুন",
      "calculating": "গণনা করা হচ্ছে...",
      "fertilizer_calculator": "সার ক্যালকুলেটর",
      "select_crop": "ফসল নির্বাচন করুন",
      "soil_type": "মাটির ধরন",
      "weather": "আবহাওয়া",
      "land_area": "জমির আয়তন (একর হিসাবে)",
      "calculation_result": "গণনার ফলাফল",
      "verified_agri_advice": "যাচাইকৃত কৃষি পরামর্শ",
      "wheat": "গম",
      "rice": "চাল (ধান)",
      "potato": "আলু",
      "tomato": "টমেটো",
      "alluvial": "পলি",
      "black": "কালো",
      "sandy": "বেলে",
      "normal": "স্বাভাবিক",
      "dry": "শুষ্ক",
      "rainy": "বৃষ্টিবহুল"
    },
    'ta': {
      "app_title": "டிஜிட்டல் அக்ரோனமிஸ்ட்",
      "smart_farmer_ai": "விவசாய மையம்",
      "ai_powered": "துல்லியம்",
      "monitoring_health": "உங்கள் வயலின் ஆரோக்கியத்தை நிகழ்நேரத்தில் கண்காணித்தல்",
      "partly_cloudy": "ஓரளவு மேகமூட்டம்",
      "humidity": "ஈரப்பதம்",
      "smart_tip": "ஸ்மார்ட் உதவிக்குறிப்பு",
      "weather_note_home": "இன்று நைட்ரஜன் உரம் இட ஏற்ற வானிலை.",
      "scan_crop": "பயிரை ஸ்கேன் செய்க",
      "scan_crop_desc": "AI ஐக் கொண்டு பூச்சிகள் மற்றும் நோய்களை உடனடியாக கண்டறியவும்.",
      "upload_image": "படத்தைப் பதிவேற்றுக",
      "upload_image_desc": "கேலரியிலிருந்து பழைய படங்களை பகுப்பாய்வு செய்யவும்.",
      "mandi_prices": "மண்டி விலை",
      "mandi_prices_desc": "நிகழ்நேர சந்தை விலை மற்றும் போக்கு பகுப்பாய்வு.",
      "fertilizer": "உரம்",
      "fertilizer_desc": "ஊட்டச்சத்து திட்டங்கள் மற்றும் உரம் கால்குலேட்டர்.",
      "crop_suggest": "பயிர் பரிந்துரை",
      "crop_suggest_desc": "உங்கள் மண்ணின் அடிப்படையில் சரியான பரிந்துரைகள்.",
      "select_language": "மொழியைத் தேர்ந்தெடுக்கவும்",
      "english": "English",
      "hindi": "हिंदी",
      "point_at_crop": "நேரலை ஐடிக்கு பயிரை நோக்கி கேமராவைக் காட்டவும்",
      "diagnosis_result": "நோயறிதல் முடிவு",
      "selected_crop": "தேர்ந்தெடுக்கப்பட்ட பயிர்",
      "detected_disease": "கண்டறியப்பட்ட நோய்",
      "ai_confidence": "AI துல்லியம்",
      "ai_agronomist_advice": "AI விவசாய நிபுணர் ஆலோசனை",
      "scan_another_crop": "மற்றொரு பயிரை ஸ்கேன் செய்க",
      "calculating": "கணக்கிடப்படுகிறது...",
      "fertilizer_calculator": "உரம் கால்குலேட்டர்",
      "select_crop": "பயிரைத் தேர்ந்தெடுக்கவும்",
      "soil_type": "மண் வகை",
      "weather": "வானிலை",
      "land_area": "நிலப்பரப்பு (ஏக்கரில்)",
      "calculation_result": "கணக்கீட்டு முடிவு",
      "verified_agri_advice": "சரிபார்க்கப்பட்ட விவசாய ஆலோசனை",
      "wheat": "கோதுமை",
      "rice": "அரிசி",
      "potato": "உருளைக்கிழங்கு",
      "tomato": "தக்காளி",
      "alluvial": "வண்டல்",
      "black": "கரிசல்",
      "sandy": "மணல்",
      "normal": "சாதாரண",
      "dry": "வறண்ட",
      "rainy": "மழைக்கால"
    }
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'bn', 'mr', 'ta', 'te', 'gu', 'kn', 'ml', 'pa', 'or']
        .contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // Synchronous load avoids ANY rootBundle.loadString() FilePathNotFound crashes!
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// Extension to make translation easy: context.loc('key')
extension AppLocalizationsExtension on BuildContext {
  String loc(String key) {
    return AppLocalizations.of(this)?.translate(key) ?? key;
  }
}
