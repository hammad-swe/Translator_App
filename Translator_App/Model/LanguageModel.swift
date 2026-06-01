//
//  LanguageModel.swift
//  Translator_App
//
//  Created by Hammad Ali on 18/05/2026.
//

import Foundation

// MARK: - MyMemory Translation API
struct MyMemoryResponse: Decodable, Sendable {
    let responseData: MyMemoryTranslation
    let responseStatus: Int
    let responseDetails: String?
}

struct MyMemoryTranslation: Decodable, Sendable {
    let translatedText: String
}

// MARK: - Language Model
struct Language: Codable, Sendable {
    let code: String
    let name: String

    init(code: String, name: String) {
        self.code = code
        self.name = name
    }
}

// MARK: - API Response Models
struct FirstOrgResponse: Decodable, Sendable {
    let data: [String: String]
}

struct CountryLanguages: Decodable {
    let languages: [String: String]?
}

//// MARK: - Language Info (Flag + Country)
struct LanguageInfo {
    let code: String
    let name: String
    let countryCode: String

    var flagEmoji: String {
        countryCode.uppercased().unicodeScalars.compactMap {
            Unicode.Scalar(127397 + $0.value)
        }.map(String.init).joined()
    }
}

// MARK: - All Supported Languages
extension LanguageInfo {
    static let all: [LanguageInfo] = [
        LanguageInfo(code: "af", name: "Afrikaans",          countryCode: "ZA"),
        LanguageInfo(code: "sq", name: "Albanian",           countryCode: "AL"),
        LanguageInfo(code: "am", name: "Amharic",            countryCode: "ET"),
        LanguageInfo(code: "ar", name: "Arabic",             countryCode: "SA"),
        LanguageInfo(code: "hy", name: "Armenian",           countryCode: "AM"),
        LanguageInfo(code: "az", name: "Azerbaijani",        countryCode: "AZ"),
        LanguageInfo(code: "be", name: "Belarusian",         countryCode: "BY"),
        LanguageInfo(code: "bn", name: "Bengali",            countryCode: "BD"),
        LanguageInfo(code: "bs", name: "Bosnian",            countryCode: "BA"),
        LanguageInfo(code: "bg", name: "Bulgarian",          countryCode: "BG"),
        LanguageInfo(code: "ca", name: "Catalan",            countryCode: "ES"),
        LanguageInfo(code: "zh", name: "Chinese",            countryCode: "CN"),
        LanguageInfo(code: "hr", name: "Croatian",           countryCode: "HR"),
        LanguageInfo(code: "cs", name: "Czech",              countryCode: "CZ"),
        LanguageInfo(code: "da", name: "Danish",             countryCode: "DK"),
        LanguageInfo(code: "nl", name: "Dutch",              countryCode: "NL"),
        LanguageInfo(code: "en", name: "English",            countryCode: "GB"),
        LanguageInfo(code: "et", name: "Estonian",           countryCode: "EE"),
        LanguageInfo(code: "fi", name: "Finnish",            countryCode: "FI"),
        LanguageInfo(code: "fr", name: "French",             countryCode: "FR"),
        LanguageInfo(code: "gl", name: "Galician",           countryCode: "ES"),
        LanguageInfo(code: "ka", name: "Georgian",           countryCode: "GE"),
        LanguageInfo(code: "de", name: "German",             countryCode: "DE"),
        LanguageInfo(code: "el", name: "Greek",              countryCode: "GR"),
        LanguageInfo(code: "gu", name: "Gujarati",           countryCode: "IN"),
        LanguageInfo(code: "ht", name: "Haitian Creole",     countryCode: "HT"),
        LanguageInfo(code: "ha", name: "Hausa",              countryCode: "NG"),
        LanguageInfo(code: "he", name: "Hebrew",             countryCode: "IL"),
        LanguageInfo(code: "hi", name: "Hindi",              countryCode: "IN"),
        LanguageInfo(code: "hu", name: "Hungarian",          countryCode: "HU"),
        LanguageInfo(code: "is", name: "Icelandic",          countryCode: "IS"),
        LanguageInfo(code: "ig", name: "Igbo",               countryCode: "NG"),
        LanguageInfo(code: "id", name: "Indonesian",         countryCode: "ID"),
        LanguageInfo(code: "ga", name: "Irish",              countryCode: "IE"),
        LanguageInfo(code: "it", name: "Italian",            countryCode: "IT"),
        LanguageInfo(code: "ja", name: "Japanese",           countryCode: "JP"),
        LanguageInfo(code: "kn", name: "Kannada",            countryCode: "IN"),
        LanguageInfo(code: "kk", name: "Kazakh",             countryCode: "KZ"),
        LanguageInfo(code: "km", name: "Khmer",              countryCode: "KH"),
        LanguageInfo(code: "ko", name: "Korean",             countryCode: "KR"),
        LanguageInfo(code: "ku", name: "Kurdish",            countryCode: "IQ"),
        LanguageInfo(code: "ky", name: "Kyrgyz",             countryCode: "KG"),
        LanguageInfo(code: "lo", name: "Lao",                countryCode: "LA"),
        LanguageInfo(code: "lv", name: "Latvian",            countryCode: "LV"),
        LanguageInfo(code: "lt", name: "Lithuanian",         countryCode: "LT"),
        LanguageInfo(code: "lb", name: "Luxembourgish",      countryCode: "LU"),
        LanguageInfo(code: "mk", name: "Macedonian",         countryCode: "MK"),
        LanguageInfo(code: "mg", name: "Malagasy",           countryCode: "MG"),
        LanguageInfo(code: "ms", name: "Malay",              countryCode: "MY"),
        LanguageInfo(code: "ml", name: "Malayalam",          countryCode: "IN"),
        LanguageInfo(code: "mt", name: "Maltese",            countryCode: "MT"),
        LanguageInfo(code: "mi", name: "Maori",              countryCode: "NZ"),
        LanguageInfo(code: "mr", name: "Marathi",            countryCode: "IN"),
        LanguageInfo(code: "mn", name: "Mongolian",          countryCode: "MN"),
        LanguageInfo(code: "my", name: "Myanmar (Burmese)",  countryCode: "MM"),
        LanguageInfo(code: "ne", name: "Nepali",             countryCode: "NP"),
        LanguageInfo(code: "nb", name: "Norwegian",          countryCode: "NO"),
        LanguageInfo(code: "ps", name: "Pashto",             countryCode: "AF"),
        LanguageInfo(code: "fa", name: "Persian",            countryCode: "IR"),
        LanguageInfo(code: "pl", name: "Polish",             countryCode: "PL"),
        LanguageInfo(code: "pt", name: "Portuguese",         countryCode: "PT"),
        LanguageInfo(code: "pa", name: "Punjabi",            countryCode: "IN"),
        LanguageInfo(code: "ro", name: "Romanian",           countryCode: "RO"),
        LanguageInfo(code: "ru", name: "Russian",            countryCode: "RU"),
        LanguageInfo(code: "sm", name: "Samoan",             countryCode: "WS"),
        LanguageInfo(code: "sr", name: "Serbian",            countryCode: "RS"),
        LanguageInfo(code: "sn", name: "Shona",              countryCode: "ZW"),
        LanguageInfo(code: "sd", name: "Sindhi",             countryCode: "PK"),
        LanguageInfo(code: "si", name: "Sinhala",            countryCode: "LK"),
        LanguageInfo(code: "sk", name: "Slovak",             countryCode: "SK"),
        LanguageInfo(code: "sl", name: "Slovenian",          countryCode: "SI"),
        LanguageInfo(code: "so", name: "Somali",             countryCode: "SO"),
        LanguageInfo(code: "es", name: "Spanish",            countryCode: "ES"),
        LanguageInfo(code: "sw", name: "Swahili",            countryCode: "TZ"),
        LanguageInfo(code: "sv", name: "Swedish",            countryCode: "SE"),
        LanguageInfo(code: "tl", name: "Filipino",           countryCode: "PH"),
        LanguageInfo(code: "tg", name: "Tajik",              countryCode: "TJ"),
        LanguageInfo(code: "ta", name: "Tamil",              countryCode: "IN"),
        LanguageInfo(code: "tt", name: "Tatar",              countryCode: "RU"),
        LanguageInfo(code: "te", name: "Telugu",             countryCode: "IN"),
        LanguageInfo(code: "th", name: "Thai",               countryCode: "TH"),
        LanguageInfo(code: "tr", name: "Turkish",            countryCode: "TR"),
        LanguageInfo(code: "tk", name: "Turkmen",            countryCode: "TM"),
        LanguageInfo(code: "uk", name: "Ukrainian",          countryCode: "UA"),
        LanguageInfo(code: "ur", name: "Urdu",               countryCode: "PK"),
        LanguageInfo(code: "uz", name: "Uzbek",              countryCode: "UZ"),
        LanguageInfo(code: "vi", name: "Vietnamese",         countryCode: "VN"),
        LanguageInfo(code: "cy", name: "Welsh",              countryCode: "GB"),
        LanguageInfo(code: "xh", name: "Xhosa",              countryCode: "ZA"),
        LanguageInfo(code: "yi", name: "Yiddish",            countryCode: "IL"),
        LanguageInfo(code: "yo", name: "Yoruba",             countryCode: "NG"),
        LanguageInfo(code: "zu", name: "Zulu",               countryCode: "ZA"),
    ]
}
