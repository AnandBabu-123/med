class AppStrings {

  static Map<String, Map<String, String>> values = {

    "English": {
      "getStarted": "Let's get started",
      "enterMobile": "Enter Mobile Number",
      "hintMobile": "+ 91 Mobile Number",
      "phone": "Phone",
      "referralOptional": "Referral Code (Optional)",
      "hintReferral": "Enter referral code",
      "terms": "By continuing, you agree to our Terms & Conditions",
      "continue": "Continue",
      "termsPrefix": "By continuing, you agree to our ",
      "termsLink": "Terms & Conditions",
      "enterOtp": "Enter 4-digit OTP sent to",
      "didntReceive": "Didn't receive the code?",
      "resend": "Resend",
    },

    "Telugu": {
      "getStarted": "ప్రారంభిద్దాం",
      "enterMobile": "మొబైల్ నంబర్ నమోదు చేయండి",
      "hintMobile": "+91 మొబైల్ నంబర్",
      "phone": "ఫోన్",
      "referralOptional": "రిఫరల్ కోడ్ (ఐచ్చికం)",
      "hintReferral": "రిఫరల్ కోడ్ నమోదు చేయండి",
      "terms": "కొనసాగించడం ద్వారా, మీరు మా నిబంధనలు & షరతులకు అంగీకరిస్తున్నారు",
      "continue": "కొనసాగించండి",
      "termsPrefix": "కొనసాగించడం ద్వారా, మీరు మా ",
      "termsLink": "నిబంధనలు & షరతులు",
      "enterOtp": "మీ నంబర్‌కు పంపిన 4 అంకెల OTP నమోదు చేయండి",
      "didntReceive": "కోడ్ రాలేదా?",
      "resend": "మళ్లీ పంపండి",
    }

  };

  static String get(String language, String key) {
    return values[language]?[key] ?? "";
  }
}