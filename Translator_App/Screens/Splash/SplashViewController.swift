//
//  SplashViewController.swift
//  Translator_App
//
//  Created by Hammad Ali on 18/05/2026.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        startSplashTimer()
        // Do any additional setup after loading the view.
    }
    
    
    private func startSplashTimer() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
                self?.navigateToNextScreen()
                
            }
            
        }


    private func navigateToNextScreen() {
            let vc = MainViewController()
            self.navigationController?.setViewControllers([vc], animated: true)
        }

}
