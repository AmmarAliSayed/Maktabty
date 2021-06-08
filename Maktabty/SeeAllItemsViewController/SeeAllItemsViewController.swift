//
//  SeeAllItemsViewController.swift
//  Maktabty
//
//  Created by Macbook on 30/05/2021.
//

import UIKit
import NVActivityIndicatorView
import FirebaseAuth
class SeeAllItemsViewController: UIViewController {
    //MARK: - IBOutlets
        @IBOutlet weak var myCollectionView: UICollectionView!{
            didSet{
                myCollectionView.delegate = self
                myCollectionView.dataSource = self
            }
        }
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addItemOutlet: UIBarButtonItem!
    
    //MARK: - Vars
    var itemsArray : [Item] = []
    var filteredItems : [Item] = []
    var isSearching = false
    var activityIndicator: NVActivityIndicatorView?
    //set margins of the cell
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    private let itemsPerRow: CGFloat = 2
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadItems()
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60.0, height: 60.0), type: .ballPulse, color: #colorLiteral(red: 1, green: 0.431372549, blue: 0.631372549, alpha: 1), padding: nil)
        disableAddItemButton()
    }
    //MARK: - Load Books from firebase
    
    private func loadItems() {
        retrieveItemsFromFirebase { (itemsArr) in
            self.itemsArray = itemsArr
            self.myCollectionView.reloadData()
            
        }
    }
    //MARK: - Search database

    private func searchInFirebase(forName: String) {

        showLoadingIndicator()

        searchItemInAlgolia(searchString: forName) { (itemIds) in
            downloadItemsForSearch(itemIds) { (items) in
                self.filteredItems = items
              //  self.myCollectionView.reloadData()
                self.hideLoadingIndicator()
            }
        }
    }
    
    //MARK: - Activity indicator
    
    private func showLoadingIndicator() {
        
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }

    private func hideLoadingIndicator() {
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
        
    }
    private func disableAddItemButton(){
        //"wpr4nAyfkASGUqTp3lve1OoDsDU2"  -> admin userId who only can add items
        if Auth.auth().currentUser?.uid == "wpr4nAyfkASGUqTp3lve1OoDsDU2" {
            addItemOutlet.isEnabled = true
        }else{
            addItemOutlet.isEnabled = false
        }
    }
}
extension SeeAllItemsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (isSearching) {
            return  filteredItems.count
           }
           else {
            return itemsArray.count
           }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: OtherCollectionViewCell.self) , for: indexPath) as? OtherCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 2
        cell.contentView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        
        if isSearching {
            cell.itemLabel.text = filteredItems[indexPath.row].itemName
        }else{
            cell.itemLabel.text = itemsArray[indexPath.row].itemName
            
            if itemsArray[indexPath.row].imageLinks.count > 0 {
                downloadImagesFromFirebase(imageUrls: [itemsArray[indexPath.row].imageLinks.first!]) { (images) in
                    DispatchQueue.main.async {
                        cell.itemImageView.image = images.first as? UIImage
                    }
                }
            }
        }
       
        return cell
    }
   
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        guard let itemDetailsViewController = self.storyboard?.instantiateViewController(identifier: String(describing: ItemDetailsViewController.self)) as? ItemDetailsViewController else {
            return
        }
        itemDetailsViewController.item = itemsArray[indexPath.row]
        self.present(itemDetailsViewController, animated: true, completion: nil)
    }
}
extension SeeAllItemsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let withPerItem = availableWidth / itemsPerRow

        return CGSize(width: withPerItem, height: withPerItem)
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
        
    }
}

extension SeeAllItemsViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.count != 0) {
            isSearching = true
            searchInFirebase(forName: searchText)
        }else{
            self.hideLoadingIndicator()
            isSearching = false
        }
        self.myCollectionView.reloadData()
    
      }
    }
       



   



