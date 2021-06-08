//
//  SignUpViewController.swift
//  Maktabty
//
//  Created by Macbook on 19/05/2021.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView
import Gallery
class SignUpViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    //MARK: - Vars
    
    let hud = JGProgressHUD(style: .dark)
    var activityIdicator: NVActivityIndicatorView?
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addImageToTextField()
        //make button rounded
        signUpButton.layer.cornerRadius = 10
        setUpElements()
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIdicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60.0, height: 60.0), type: .ballPulse, color: #colorLiteral(red: 1, green: 0.431372549, blue: 0.631372549, alpha: 1), padding: nil)
        
    }
   
    //MARK: - IBActions
    @IBAction func signUpButtonPressed(_ sender: Any) {
       // print("register")
        
        if textFieldsHaveText() {
            registerUser()
        } else {
            hud.textLabel.text = "All fields are required"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    //MARK: - Register User
    
    private func registerUser() {
        
        showLoadingIdicator()
        
        let userName = nameTextField.text
        let email = emailTextField.text
        
       
        let phone = phoneTextField.text
        let password = passwordTextField.text
       
       
        registerUserWith(email: email!, password: password!, userName: userName!, phone: phone!) { [self] (error) in
            if error == nil {
                self.hud.textLabel.text = "Registration operation done!"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                //dismiss the view
                self.dismissView()
            } else {
                print("error registering", error!.localizedDescription)
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            
            
            self.hideLoadingIdicator()
        }
        
        
    }
    
 
    //MARK: - Helper Functions
    
    private func addImageToTextField(){
        
        let nameImage = UIImage(named:"user2")
        addLeftImageTo(txtField: nameTextField, andImage: nameImage!)
        
        let phoneImage = UIImage(named:"phone2")
    
        addLeftImageTo(txtField: phoneTextField, andImage: phoneImage!)
        
        let emailImage = UIImage(named:"mail2")
        addLeftImageTo(txtField: emailTextField, andImage: emailImage!)
        
        let passwordImage = UIImage(named:"password2")
        addLeftImageTo(txtField: passwordTextField, andImage: passwordImage!)
    }
    private func addLeftImageTo(txtField: UITextField, andImage img: UIImage) {
        let leftImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height))
        leftImageView.image = img
        txtField.leftView = leftImageView
        txtField.leftViewMode = .always
    }
    func setUpElements() {
        // Style the elements
        Utilities.styleTextField(nameTextField)
        Utilities.styleTextField(phoneTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
       
    }
    private func dismissView() {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    private func textFieldsHaveText() -> Bool {
        return (emailTextField.text != "" && passwordTextField.text != "" && nameTextField.text != "" && phoneTextField.text != "")
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
}




