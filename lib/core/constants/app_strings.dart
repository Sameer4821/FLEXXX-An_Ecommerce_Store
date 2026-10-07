/// App Strings & Multi-language Support System
class AppStrings {
  static const String appName = "FLEXXX";
  static const String appBrandTagline = "Shopping Redesigned for the Next Decade";

  // Current language selection holder
  static String currentLanguage = 'en';

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'greeting_morning': 'Good morning 👋',
      'greeting_afternoon': 'Good afternoon 👋',
      'greeting_evening': 'Good evening 👋',
      'search_placeholder': 'Search sneakers, laptops, audio...',
      'flash_deals': 'Flash Deals',
      'explore_mode': 'Explore Feed',
      'categories': 'Categories',
      'for_you': 'For You',
      'trending_near_you': 'Trending Near You',
      'add_to_cart': 'Add to Cart',
      'buy_now': 'Buy Now',
      'cart': 'Cart',
      'wishlist': 'Wishlist',
      'checkout': 'Checkout',
      'orders': 'Orders',
      'profile': 'Profile',
      'rewards': 'Rewards',
      'settings': 'Settings',
      'apply_coupon': 'Apply Coupon',
      'order_summary': 'Order Summary',
      'free_delivery': 'FREE Delivery',
      'pay_with_upi': 'Pay via UPI / Cards / COD',
    },
    'hi': {
      'greeting_morning': 'शुभ प्रभात 👋',
      'greeting_afternoon': 'नमस्कार 👋',
      'greeting_evening': 'शुभ संध्या 👋',
      'search_placeholder': 'जूते, लैपटॉप, ऑडियो खोजें...',
      'flash_deals': 'आज की बड़ी डील्स',
      'explore_mode': 'एक्सप्लोर फ़ीड',
      'categories': 'श्रेणियाँ',
      'for_you': 'आपके लिए',
      'trending_near_you': 'आपके पास ट्रेंडिंग',
      'add_to_cart': 'कार्ट में जोड़ें',
      'buy_now': 'अभी खरीदें',
      'cart': 'कार्ट',
      'wishlist': 'विशलिस्ट',
      'checkout': 'चेकआउट',
      'orders': 'ऑर्डर',
      'profile': 'प्रोफ़ाइल',
      'rewards': 'रिवार्ड्स',
      'settings': 'सेटिंग्स',
      'apply_coupon': 'कूपन लागू करें',
      'order_summary': 'ऑर्डर सारांश',
      'free_delivery': 'मुफ़्त डिलीवरी',
      'pay_with_upi': 'यूपीआई / कार्ड / सीओडी से भुगतान करें',
    },
    'te': {
      'greeting_morning': 'శుభోదయం 👋',
      'greeting_afternoon': 'నమస్కారం 👋',
      'greeting_evening': 'శుభ సాయంత్రం 👋',
      'search_placeholder': 'స్నీకర్లు, లాప్‌టాప్‌లు, ఆడియో శోధించండి...',
      'flash_deals': 'ఫ్లాష్ డీల్స్',
      'explore_mode': 'ఎక్స్‌ప్లోర్ ఫీడ్',
      'categories': 'కేటగిరీలు',
      'for_you': 'మీ కోసం',
      'trending_near_you': 'మీ ప్రాంతంలో ట్రెండింగ్',
      'add_to_cart': 'కార్ట్‌కి జోడించండి',
      'buy_now': 'ఇప్పుడే కొనండి',
      'cart': 'కార్ట్',
      'wishlist': 'విష్‌లిస్ట్',
      'checkout': 'చెకౌట్',
      'orders': 'ఆర్డర్లు',
      'profile': 'ప్రొఫైల్',
      'rewards': 'రివార్డులు',
      'settings': 'సెట్టింగ్‌లు',
      'apply_coupon': 'కూపన్ వర్తింపజేయండి',
      'order_summary': 'ఆర్డర్ సారాంశం',
      'free_delivery': 'ఉచిత డెలివరీ',
      'pay_with_upi': 'యూపీఐ / కార్డ్‌లు / సిఓడి ద్వారా చెల్లించండి',
    }
  };

  static String get(String key) {
    return _localizedValues[currentLanguage]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }
}
