//
//  ProfileTableViewController.swift
//  Maktabty
//
//  Created by Macbook on 25/05/2021.
//

import UIKit
import FirebaseAuth
class ProfileTableViewController: UITableViewController {

   // @IBOutlet weak var loginButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var profileDetailsButtonOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //remove empty cells
        tableView.tableFooterView = UIView()
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        disableprofileDetailsButton()
       // disableLoginButton()
    }
    @IBAction func profileDetailsPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "toProfileDetailsSegue", sender: nil)
    }
    
//    @IBAction func loginButtonPressed(_ sender: Any) {
//
//    }
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
//MARK: - helpper functions
    private func disableprofileDetailsButton(){
        if Auth.auth().currentUser != nil  {
            profileDetailsButtonOutlet.isEnabled = true
        }else{
            profileDetailsButtonOutlet.isEnabled = false
            profileDetailsButtonOutlet.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        }
    }
//    private func disableLoginButton(){
//        if Auth.auth().currentUser != nil  {
//            loginButtonOutlet.isEnabled = false
//            loginButtonOutlet.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//        }else{
//            loginButtonOutlet.isEnabled = true
//        }
//    }
//

}
