//
//  HomeTableViewController.swift
//  Maktabty
//
//  Created by Macbook on 04/05/2021.
//

import UIKit

class HomeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //hide back btn
       // self.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.setHidesBackButton(true, animated: false)
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Configure the cell...
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BooksTableViewCell.self)) as? BooksTableViewCell else {
                return UITableViewCell()
            }
            // set delegate 
            cell.delegate = self
            //cell.BooksCollectionView.reloadData()
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NovelsTableViewCell.self)) as? NovelsTableViewCell else {
                return UITableViewCell()
            }
            // set delegate
            cell.delegate = self
            return cell
       
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OtherTableViewCell.self)) as? OtherTableViewCell else {
                return UITableViewCell()
            }
            // set delegate
            cell.delegate = self
            return cell
            
        default:
            return UITableViewCell()
        }
       
    }
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return 250
        case 1:
            return 250
        case 2:
            return 250
        default:
            return 100
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HomeTableViewController: BooksCellDelegate {
    func selectedBook(book: Book) {
        
         guard let bookDetailsViewController = self.storyboard?.instantiateViewController(identifier: String(describing: BookDetailsViewController.self)) as? BookDetailsViewController else {
             return
         }
        bookDetailsViewController.book = book
         self.present(bookDetailsViewController, animated: true, completion: nil)
        
    }

}

extension HomeTableViewController: NovelsCellDelegate{
    func selectedNovel(novel: Novel) {
        guard let novelDetailsViewController = self.storyboard?.instantiateViewController(identifier: String(describing: NovelDetailsViewController.self)) as? NovelDetailsViewController else {
            return
        }
        novelDetailsViewController.novel = novel
        self.present(novelDetailsViewController, animated: true, completion: nil)
    }
    
    
}
extension HomeTableViewController: ItemsCellDelegate{
    func selectedItem(item: Item) {
        guard let itemDetailsViewController = self.storyboard?.instantiateViewController(identifier: String(describing: ItemDetailsViewController.self)) as? ItemDetailsViewController else {
            return
        }
        itemDetailsViewController.item = item
        self.present(itemDetailsViewController, animated: true, completion: nil)
    }
    
   
    
    
}
