//
//  MainViewController.swift
//  Translator_App
//
//  Created by Hammad Ali on 18/05/2026.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var swapButton: UIButton!
    @IBOutlet weak var Language1: UIButton!
    @IBOutlet weak var Language2: UIButton!
    @IBOutlet weak var ButtonStack: UIStackView!
    @IBOutlet weak var InputTextView: UITextView!
    @IBOutlet weak var OutputTextView: UITextView!
    @IBOutlet weak var card1: UIStackView!
    @IBOutlet weak var card2: UIStackView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var copyButton: UIButton!
    
    
  
    
    private let languageService = LanguageService()

//    private let languages: [(name: String, code: String)] = [
//            ("English", "en"), ("Urdu", "ur"), ("Arabic", "ar"),
//            ("Spanish", "es"), ("French", "fr"), ("German", "de"),
//            ("Chinese", "zh"), ("Hindi", "hi"), ("Turkish", "tr")
//        ]
    private var languages: [Language] = []
    
    private var sourceLanguage = Language(code: "en", name: "English")
    private var targetLanguage = Language(code: "ur", name: "Urdu")
    
    
    let placeholder = "Enter text to translate..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        InputTextView.delegate = self
        InputTextView.text = placeholder
        InputTextView.textColor = .lightGray
        
        
//        updateButton(Language1, name: sourceLanguage.name, code: sourceLanguage.code, subtitle: "Source")
//        updateButton(Language2, name: targetLanguage.name, code: targetLanguage.code, subtitle: "Target")
//       
        
        // ✅ Fetch languages from API
                loadLanguages()
    }
    
    
    private func loadLanguages() {
        languageService.fetchLanguages { [weak self] result in
            DispatchQueue.main.async {
                if case .success(let langs) = result {
                    self?.languages = langs
                }
            }
        }
    }

    
    
    private func setUpUI(){
        title = "Translate App"
        ButtonStack.layer.cornerRadius = 8
        Language1.layer.cornerRadius = 8
        Language2.layer.cornerRadius = 8
        card1.layer.cornerRadius = 12
        card2.layer.cornerRadius = 12
        
    }
    
    
    
    @IBAction func translatetapped(_ sender: UIButton) {
        guard let text = InputTextView.text,
                      !text.isEmpty,
                      text != placeholder else {
                    showError("Please enter text to translate.")
                    return
                }
                
                view.endEditing(true)
                setLoading(true)
                
                languageService.translate(
                    text: text,
                    from: sourceLanguage.code,
                    to: targetLanguage.code
                ) { [weak self] result in
                    DispatchQueue.main.async {
                        self?.setLoading(false)
                        switch result {
                        case .success(let translated):
                            self?.OutputTextView.text = translated
                            self?.OutputTextView.textColor = .label
                        case .failure(let error):
                            self?.showError(error.localizedDescription)
                        }
                    }
                }
    }
    
    @IBAction func CopyTapped(_ sender: UIButton) {
        guard OutputTextView.textColor == .label else { return }
                UIPasteboard.general.string = OutputTextView.text
                copyButton.setTitle(" Copied!", for: .normal)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.copyButton.setTitle(" Copy", for: .normal)
                }
    }
    
    @IBAction func swapTapped(_ sender: UIButton) {
        
        let temp = sourceLanguage
                    sourceLanguage = targetLanguage
                    targetLanguage = temp

        updateButton(Language1, name: sourceLanguage.name, code: sourceLanguage.code, subtitle: "Source")
        updateButton(Language2, name: targetLanguage.name, code: targetLanguage.code, subtitle: "Target")

                    // ✅ Only swap text if input is not placeholder
                    let inputText = InputTextView.text == placeholder ? "" : InputTextView.text
                    InputTextView.text = OutputTextView.text
                    OutputTextView.text = inputText
                    InputTextView.textColor = .label
                    OutputTextView.textColor = .label
    }
    
    
    @IBAction func Language1Tapped(_ sender: UIButton) {
        print("✅ Language1 tapped")
            print("Languages count:", languages.count)
            showLanguagePicker(isSource: true)
    }
    
    
    @IBAction func Language2Tapped(_ sender: UIButton) {
        print("✅ Language2 tapped")
            print("Languages count:", languages.count)
            showLanguagePicker(isSource: true)
        
       
    }
    
    // MARK: - Helpers
    private func showLanguagePicker(isSource: Bool) {
        let picker = LanguagePickerViewController(
                languages: languages,
                selected: isSource ? sourceLanguage : targetLanguage,
                isSource: isSource
            )
            picker.delegate = self
        self.navigationController?.pushViewController(picker, animated: true)

//            let nav = UINavigationController(rootViewController: picker)
//            if let sheet = nav.sheetPresentationController {
//                sheet.detents = [.medium(), .large()]
//                sheet.prefersGrabberVisible = true
//                sheet.preferredCornerRadius = 20
//            }
//            present(nav, animated: true)
    }
    
    private func updateButton(_ button: UIButton, name: String, code: String, subtitle: String) {
        button.setAttributedTitle(nil, for: .normal)
        button.setTitle(nil, for: .normal)
        button.setImage(nil, for: .normal)

        let flag = emoji(for: code)

        let top = NSMutableAttributedString(
            string: "\(flag) \(name)\n",
            attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .medium),
                .foregroundColor: UIColor.label
            ]
        )
        top.append(NSAttributedString(
            string: subtitle.isEmpty ? code.uppercased() : subtitle,
            attributes: [
                .font: UIFont.systemFont(ofSize: 11),
                .foregroundColor: UIColor.secondaryLabel
            ]
        ))

        button.setAttributedTitle(top, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.separator.cgColor
        button.isUserInteractionEnabled = true
    }

    // Same emoji map, shared across VC
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
    
    
    
    
//    private func updateButton(_ button: UIButton, name: String, subtitle: String) {
//        // ✅ Clear any old attributed title first
//        button.setAttributedTitle(nil, for: .normal)
//        button.setTitle(nil, for: .normal)
//        
//        let top = NSMutableAttributedString(
//            string: name + "\n",
//            attributes: [
//                .font: UIFont.systemFont(ofSize: 14, weight: .medium),
//                .foregroundColor: UIColor.label
//            ]
//        )
//        top.append(NSAttributedString(
//            string: subtitle,
//            attributes: [
//                .font: UIFont.systemFont(ofSize: 11),
//                .foregroundColor: UIColor.secondaryLabel
//            ]
//        ))
//        
//        button.setAttributedTitle(top, for: .normal)
//        button.titleLabel?.numberOfLines = 2
//        button.titleLabel?.textAlignment = .center
//        button.titleLabel?.lineBreakMode = .byWordWrapping
//        button.contentHorizontalAlignment = .center
//        button.contentVerticalAlignment = .center
//        button.backgroundColor = .secondarySystemBackground
//        button.layer.cornerRadius = 10
//        button.layer.borderWidth = 0.5
//        button.layer.borderColor = UIColor.separator.cgColor
//        
//        // ✅ This is the key fix — without this the title blocks touches
//        button.isUserInteractionEnabled = true
//    }

//         // MARK: - Loading
    private func setLoading(_ isLoading: Bool) {
        translateButton.isEnabled = !isLoading
        translateButton.alpha = isLoading ? 0.6 : 1.0
        translateButton.setTitle(isLoading ? "Translating..." : "Translate", for: .normal)
    }

    
    // Alert
    private func showError(_ message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
}
extension MainViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
    }
}

extension MainViewController: LanguagePickerDelegate {
    func didSelectLanguage(_ language: Language, isSource: Bool) {
        if isSource {
            sourceLanguage = language
            updateButton(Language1, name: language.name,
                         code: language.code, subtitle: "Source")
        } else {
            targetLanguage = language
            updateButton(Language2, name: language.name,
                         code: language.code, subtitle: "Target")
        }
    }
}
