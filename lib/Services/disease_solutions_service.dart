class DiseaseSolutionsService {
  static String getSolution(String label) {
    // 🛡️ Normalize for robust lookup:
    // 1. Exact match (case-insensitive)
    final key = label.trim().toLowerCase();
    
    // Check direct map (standardized keys)
    final found = _solutions[key] ?? 
                 _solutions[label.trim()] ?? 
                 // Handle specific weirdness in labels.txt if it persists
                 _solutions[label.trim().replaceAll('  ', ' ').replaceAll(' ', '_')];

    return found ?? 'Consult a local agricultural expert for detailed management steps.';
  }

  static final Map<String, String> _solutions = {
    // BANANA
    'banana_bract_mosaic_virus': 'Remove and destroy infected plants. Control aphids. Use virus-free planting materials.',
    'banana_cordana': 'Improve drainage. Apply balanced potash fertilizers. Use fungicides like Mancozeb if severe.',
    'banana_healthy': 'Maintain regular monitoring. Continue balanced fertilization and proper irrigation.',
    'banana_insectpest': 'Apply neem oil or appropriate bio-pesticides. Use yellow sticky traps for monitoring.',
    'banana_moko': 'Strictly quarantine the area. Disinfect tools. Eradicate infected plants immediately.',
    'banana_panama': 'Use resistant varieties. Maintain proper soil pH. Avoid waterlogging and movement of infected soil.',
    'banana_pestalotiopsis': 'Improve plant vigor with proper nutrition. Remove old, infected leaves.',
    'banana_sigatoka': 'Ensure proper spacing for air circulation. Apply fungicides like Propiconazole or Chlorothalonil.',
    'banana_yb_sigatoka': 'Prune and burn infected leaves. Spray mineral oils or recommended fungicides.',

    // CAULIFLOWER
    'cauliflower_blackrot': 'Use disease-free seeds. Treat seeds with hot water. Rotate crops and avoid overhead irrigation.',
    'cauliflower_bacterial _spot _rot': 'Apply copper-based sprays. Remove infected debris. Avoid handling plants when wet.',
    'cauliflower_downy_mildew': 'Apply Metalaxyl or Mancozeb. Increase plant spacing. Use balanced nitrogen levels.',
    'cauliflower_healthy': 'Healthy crop. Maintain consistent moisture and weed control.',

    // CHILLI
    'chilli_anthracnose': 'Apply fungicides like Carbendazim or Mancozeb. Use certified seeds. Practice crop rotation.',
    'chilli_healthy': 'Maintain good cultural practices. Ensure proper drainage and nutrition.',
    'chilli_leafcurl': 'Control thrips and whiteflies using yellow sticky traps or Confidor/Neem oil.',
    'chilli_leafspot': 'Spray copper oxychloride or Mancozeb. Remove and burn bottom leaves showing spots.',
    'chilli_whitefly': 'Use yellow sticky traps. Spray neem-based insecticides or Imidacloprid if severe.',
    'chilli_yellowish': 'Check soil moisture and nitrogen levels. Apply balanced micro-nutrients or Epsom salt.',

    // GROUNDNUT
    'groundnut_early_leaf_spot': 'Apply Chlorothalonil or Carbendazim. Practice crop rotation with non-legumes.',
    'groundnut_early_rust': 'Spray Hexaconazole or Mancozeb. Avoid late planting and use resistant varieties.',
    'groundnut_healthy': 'Excellent growth. Keep the field weed-free and monitor for early symptoms.',
    'groundnut_late_leaf_spot': 'Apply Propiconazole or Chlorothalonil. Remove previous crop residues.',
    'groundnut_nutrition_deficiency': 'Apply Gypsum (calcium) and balanced NPK. Use Micronutrient mixtures.',
    'groundnut_rust': 'Apply sulfur-based fungicides or Hexaconazole. Avoid overhead irrigation.',

    // RADISH
    'radish_black_leaf_spot': 'Practice crop rotation. Remove crop debris. Use treated seeds and avoid excessive moisture.',
    'radish_downey_mildew': 'Apply copper fungicides. Improve soil drainage and ensure adequate plant spacing.',
    'radish_flea_beetle': 'Use row covers. Apply diatomaceous earth or neem oil. Keep field borders weed-free.',
    'radish_healthy': 'Healthy plant. Ensure consistent watering to prevent root splitting.',
    'radish_mosaic': 'Control aphids which spread the virus. Remove infected plants immediately.',
  };
}
