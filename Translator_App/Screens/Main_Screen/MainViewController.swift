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

    private let languages: [(name: String, code: String)] = [
            ("English", "en"), ("Urdu", "ur"), ("Arabic", "ar"),
            ("Spanish", "es"), ("French", "fr"), ("German", "de"),
            ("Chinese", "zh"), ("Hindi", "hi"), ("Turkish", "tr")
        ]
    private var sourceLanguage: (name: String, code: String) = ("English", "en")
        private var targetLanguage: (name: String, code: String) = ("Urdu", "ur")
    
    
    
    let placeholder = "Enter text to translate..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        InputTextView.delegate = self
        InputTextView.text = placeholder
        InputTextView.textColor = .lightGray
        
        //
        updateButton(Language1, name: sourceLanguage.name, subtitle: "Source")
        updateButton(Language2, name: targetLanguage.name, subtitle: "Target")
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

            updateButton(Language1, name: sourceLanguage.name, subtitle: "Source")
            updateButton(Language2, name: targetLanguage.name, subtitle: "Target")

            // ✅ Only swap text if input is not placeholder
            let inputText = InputTextView.text == placeholder ? "" : InputTextView.text
            InputTextView.text = OutputTextView.text
            OutputTextView.text = inputText
            InputTextView.textColor = .label
            OutputTextView.textColor = .label
    }
    
    
    @IBAction func Language1Tapped(_ sender: UIButton) {
        showLanguagePicker(isSource: true)
    }
    
    
    @IBAction func Language2Tapped(_ sender: UIButton) {
        showLanguagePicker(isSource: false)
    }
    
    // MARK: - Helpers
        private func showLanguagePicker(isSource: Bool) {
            let alert = UIAlertController(title: "Select Language",
                                          message: nil,
                                          preferredStyle: .actionSheet)

            // iPad support
            alert.popoverPresentationController?.sourceView = isSource ? Language1 : Language2

            for lang in languages {
                alert.addAction(UIAlertAction(title: lang.name, style: .default) { [weak self] _ in
                    guard let self = self else { return }
                    if isSource {
                        self.sourceLanguage = lang
                        self.updateButton(self.Language1, name: lang.name, subtitle: "")
                    } else {
                        self.targetLanguage = lang
                        self.updateButton(self.Language2, name: lang.name, subtitle: "")
                    }
                })
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert, animated: true)
        }
    
    private func updateButton(_ button: UIButton, name: String, subtitle: String) {
            let top = NSMutableAttributedString(
                string: name + "\n",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 14, weight: .medium),
                    .foregroundColor: UIColor.label
                ]
            )
            top.append(NSAttributedString(
                string: subtitle,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 11),
                    .foregroundColor: UIColor.secondaryLabel
                ]
            ))
        button.setAttributedTitle(top, for: .normal)
                button.titleLabel?.numberOfLines = 2
                button.titleLabel?.textAlignment = .left
                button.contentHorizontalAlignment = .left
                button.backgroundColor = .secondarySystemBackground
                button.layer.cornerRadius = 10
                button.layer.borderWidth = 0.5
                button.layer.borderColor = UIColor.separator.cgColor
        }

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
