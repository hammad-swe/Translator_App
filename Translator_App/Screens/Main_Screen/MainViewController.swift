//
//  MainViewController.swift
//  Translator_App
//
//  Created by Hammad Ali on 18/05/2026.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var Language1: UIButton!
    @IBOutlet weak var Language2: UIButton!
    @IBOutlet weak var ButtonStack: UIStackView!
    @IBOutlet weak var InputTextView: UITextView!
    @IBOutlet weak var OutputTextView: UITextView!
    @IBOutlet weak var card1: UIStackView!
    @IBOutlet weak var card2: UIStackView!
    let placeholder = "Enter text to translate..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI(){
        title = "Translator App"
        ButtonStack.layer.cornerRadius = 8
        Language1.layer.cornerRadius = 8
        Language2.layer.cornerRadius = 8
        card1.layer.cornerRadius = 12
        card2.layer.cornerRadius = 12
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        InputTextView.delegate = self
        InputTextView.text = placeholder
        InputTextView.textColor = .lightGray
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
