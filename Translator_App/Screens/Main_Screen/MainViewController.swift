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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Translator App"
        ButtonStack.layer.cornerRadius = 8
        Language1.layer.cornerRadius = 8
        Language2.layer.cornerRadius = 8
    }
    
    

    
}
