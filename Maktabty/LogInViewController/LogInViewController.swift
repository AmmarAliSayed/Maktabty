//
//  LogInViewController.swift
//  Maktabty
//
//  Created by Macbook on 19/05/2021.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView
class LogInViewController: UIViewController {

    
    //MARK: - IBOutlets
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
   
    //MARK: - Vars
    
    let hud = JGProgressHUD(style: .dark)
    var activityIdicator: NVActivityIndicatorView?
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addImageToTextField()
        //make button rounded
        loginButton.layer.cornerRadius = 10
        setUpElements()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        activityIdicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60.0, height: 60.0), type: .ballPulse, color: #colorLiteral(red: 1, green: 0.431372549, blue: 0.631372549, alpha: 1), padding: nil)
        
    }
   
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - Helper Functions
    
    func addImageToTextField(){
        let emailImage = UIImage(named:"mail2")
        addLeftImageTo(txtField: emailTextField, andImage: emailImage!)
        
        let passwordImage = UIImage(named:"password2")
        addLeftImageTo(txtField: passwordTextField, andImage: passwordImage!)
    }
    func addLeftImageTo(txtField: UITextField, andImage img: UIImage) {
        let leftImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height))
        leftImageView.image = img
        txtField.leftView = leftImageView
        txtField.leftViewMode = .always
    }
    
    func setUpElements() {
        // Style the elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
    }
    private func goToAnotherView() {
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeTableViewController") as! HomeTableViewController
//        self.navigationController?.pushViewController(homeViewController, animated: true)
        self.performSegue(withIdentifier: "fromSignInToTaBar", sender: nil)
    }
    private func textFieldsHaveText() -> Bool {
        return (emailTextField.text != "" && passwordTextField.text != "")
    }
    //MARK: - Activity Indicator
    
    private func showLoadingIdicator() {
        
        if activityIdicator != nil {
            self.view.addSubview(activityIdicator!)
            activityIdicator!.startAnimating()
        }
        
    }

    private func hideLoadingIdicator() {
        
        if activityIdicator != nil {
            activityIdicator!.removeFromSuperview()
            activityIdicator!.stopAnimating()
        }
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        if textFieldsHaveText() {
            loginUser()
        } else {
            hud.textLabel.text = "All fields are required"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
        
    }
    
    //MARK: - Login User
    
    private func loginUser() {
        
        showLoadingIdicator()
        
        loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            
            if error == nil {
                self.goToAnotherView()
            } else {
                print("error loging in the iser", error!.localizedDescription)
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            
            
            self.hideLoadingIdicator()
        }
    }
  
}
