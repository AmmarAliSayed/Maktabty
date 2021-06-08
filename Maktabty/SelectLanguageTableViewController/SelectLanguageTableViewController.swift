//
//  SelectLanguageTableViewController.swift
//  Maktabty
//
//  Created by Macbook on 30/05/2021.
//

import UIKit
import MOLH
class SelectLanguageTableViewController: UITableViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var EnglishButton: UIButton!
    @IBOutlet weak var arabicButton: UIButton!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //remove empty cells
        tableView.tableFooterView = UIView()
    }
//MARK: - IBActions
    @IBAction func arabicButtonPressed(_ sender: Any) {
        arabicButton.setTitleColor(#colorLiteral(red: 1, green: 0.431372549, blue: 0.631372549, alpha: 1), for: .normal)
        EnglishButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        //make app language to arabic
      //  MOLH.setLanguageTo("ar")
        MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
        //restart the app
        MOLH.reset()
       
    }
    @IBAction func EnglishButtonPressed(_ sender: Any) {
        EnglishButton.setTitleColor(#colorLiteral(red: 1, green: 0.431372549, blue: 0.631372549, alpha: 1), for: .normal)
        arabicButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        //make app language to english
       // MOLH.setLanguageTo("en")
        MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
        //restart the app
        MOLH.reset()
       
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
