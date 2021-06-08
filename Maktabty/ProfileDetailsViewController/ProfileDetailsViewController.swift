//
//  ProfileDetailsViewController.swift
//  Maktabty
//
//  Created by Macbook on 25/05/2021.
//

import UIKit
import FirebaseAuth
class ProfileDetailsViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //stackView
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        //make pic circular
       // userImageView.layer.borderWidth = 1.0
       // userImageView.layer.masksToBounds = false
        //userImageView.layer.borderColor = #colorLiteral(red: 1, green: 0.431372549, blue: 0.631372549, alpha: 1)
        userImageView.layer.cornerRadius = userImageView.frame.size.width/2
       // userImageView.clipsToBounds=true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadUserInfo()
    }
//MARK: - IBActions
    @IBAction func editButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "fromProfileToEditSegue", sender: nil)
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        logOutUser()
    }
    
    //MARK: - UpdateUI
    
    private func loadUserInfo() {
        
        if Auth.auth().currentUser != nil {
            let userId = Auth.auth().currentUser?.uid
            retriveUserFromFirestore(userId: userId!) { (user) in
                self.nameLabel.text = user!.name
                self.emailLabel.text = user?.email
                self.phoneLabel.text = user?.phone
                
                if (user?.imageLinks.count)! > 0 {
                    downloadImagesFromFirebase(imageUrls:[(user?.imageLinks.first!)!]) { (images) in
                        DispatchQueue.main.async { [self] in
                            userImageView.image = images.first as? UIImage
                        }
                    }
                }
            }
            
           
            
        }
    }
    private func logOutUser() {
        logOutCurrentUser { (error) in
            
            if error == nil {
                print("logged out")
                self.navigationController?.popViewController(animated: true)
            }  else {
                print("error login out ", error!.localizedDescription)
            }
        }
        
    }
}
