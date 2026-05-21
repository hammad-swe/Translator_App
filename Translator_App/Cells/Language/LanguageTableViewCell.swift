//
//  LanguageTableViewCell.swift
//  Translator_App
//
//  Created by Hammad Ali on 21/05/2026.
//

import UIKit

final class LanguageTableViewCell: UITableViewCell {

    static let identifier = "LanguageTableViewCell"
    static let nib = UINib(nibName: "LanguageTableViewCell", bundle: nil)

    // MARK: - IBOutlets

    @IBOutlet weak var flaglabel: UILabel!
    
    @IBOutlet weak var namelabel: UILabel!
    
    @IBOutlet weak var selectedIndicator: UIImageView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedIndicator.image = UIImage(systemName: "checkmark.circle.fill")
        selectedIndicator.tintColor = .systemBlue
        selectionStyle = .none
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        flaglabel.text = nil
        selectedIndicator.isHidden = true
        backgroundColor = .secondarySystemGroupedBackground
    }

    // MARK: - Configure
    func configure(with language: Language, isSelected: Bool) {
        namelabel.text = language.name
       // codeLabel.text = language.code.uppercased()
        flaglabel.text = emoji(for: language.code)
        selectedIndicator.isHidden = !isSelected
        backgroundColor = isSelected
            ? UIColor.systemBlue.withAlphaComponent(0.08)
            : .secondarySystemGroupedBackground
    }

    // MARK: - Emoji flag
    private func emoji(for code: String) -> String {
        let map: [String: String] = [
            "af": "🇿🇦", "sq": "🇦🇱", "am": "🇪🇹", "ar": "🇸🇦", "hy": "🇦🇲",
            "az": "🇦🇿", "be": "🇧🇾", "bn": "🇧🇩", "bs": "🇧🇦", "bg": "🇧🇬",
            "ca": "🇪🇸", "zh": "🇨🇳", "hr": "🇭🇷", "cs": "🇨🇿", "da": "🇩🇰",
            "nl": "🇳🇱", "en": "🇬🇧", "et": "🇪🇪", "fi": "🇫🇮", "fr": "🇫🇷",
            "gl": "🇪🇸", "ka": "🇬🇪", "de": "🇩🇪", "el": "🇬🇷", "gu": "🇮🇳",
            "ht": "🇭🇹", "ha": "🇳🇬", "he": "🇮🇱", "hi": "🇮🇳", "hu": "🇭🇺",
            "is": "🇮🇸", "ig": "🇳🇬", "id": "🇮🇩", "ga": "🇮🇪", "it": "🇮🇹",
            "ja": "🇯🇵", "kn": "🇮🇳", "kk": "🇰🇿", "km": "🇰🇭", "ko": "🇰🇷",
            "ku": "🇮🇶", "ky": "🇰🇬", "lo": "🇱🇦", "lv": "🇱🇻", "lt": "🇱🇹",
            "lb": "🇱🇺", "mk": "🇲🇰", "mg": "🇲🇬", "ms": "🇲🇾", "ml": "🇮🇳",
            "mt": "🇲🇹", "mi": "🇳🇿", "mr": "🇮🇳", "mn": "🇲🇳", "my": "🇲🇲",
            "ne": "🇳🇵", "nb": "🇳🇴", "nn": "🇳🇴", "ps": "🇦🇫", "fa": "🇮🇷",
            "pl": "🇵🇱", "pt": "🇵🇹", "pa": "🇮🇳", "ro": "🇷🇴", "ru": "🇷🇺",
            "sm": "🇼🇸", "sr": "🇷🇸", "sn": "🇿🇼", "sd": "🇵🇰", "si": "🇱🇰",
            "sk": "🇸🇰", "sl": "🇸🇮", "so": "🇸🇴", "es": "🇪🇸", "sw": "🇹🇿",
            "sv": "🇸🇪", "tl": "🇵🇭", "tg": "🇹🇯", "ta": "🇮🇳", "tt": "🇷🇺",
            "te": "🇮🇳", "th": "🇹🇭", "tr": "🇹🇷", "tk": "🇹🇲", "uk": "🇺🇦",
            "ur": "🇵🇰", "uz": "🇺🇿", "vi": "🇻🇳", "cy": "🏴󠁧󠁢󠁷󠁬󠁳󠁿", "xh": "🇿🇦",
            "yi": "🇮🇱", "yo": "🇳🇬", "zu": "🇿🇦"
        ]
        return map[code.lowercased()] ?? "🌐"
    }
}
