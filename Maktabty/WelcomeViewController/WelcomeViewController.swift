//
//  WelcomeViewController.swift
//  Maktabty
//
//  Created by Macbook on 08/05/2021.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        //hide back btn
        self.navigationItem.hidesBackButton = true
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.cornerRadius = 10
        signUpButton.layer.borderColor = #colorLiteral(red: 1, green: 0.431372549, blue: 0.631372549, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func logInButtonPressed(_ sender: Any) {
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "fromWelcomeToSignUpSegue", sender: nil)
    }
}
