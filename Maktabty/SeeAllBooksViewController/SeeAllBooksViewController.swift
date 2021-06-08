//
//  SeeAllBooksViewController.swift
//  Maktabty
//
//  Created by Macbook on 23/05/2021.
//

import UIKit
import NVActivityIndicatorView
import FirebaseAuth
class SeeAllBooksViewController: UIViewController {
//MARK: - IBOutlets
    @IBOutlet weak var myCollectionView: UICollectionView!{
        didSet{
            myCollectionView.delegate = self
            myCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var addBookOutlet: UIBarButtonItem!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - Vars
    var booksArray : [Book] = []
    var filteredBooks : [Book] = []
    var isSearching = false
    var activityIndicator: NVActivityIndicatorView?
    //set margins of the cell
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    private let itemsPerRow: CGFloat = 2
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
       // myCollectionView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadItems()
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60.0, height: 60.0), type: .ballPulse, color: #colorLiteral(red: 1, green: 0.431372549, blue: 0.631372549, alpha: 1), padding: nil)
        disableAddBookButton()
    }
    //MARK: - Load Books from firebase
    
    private func loadItems() {
        retrieveBooksFromFirebase { (booksArr) in
            self.booksArray = booksArr
            self.myCollectionView.reloadData()
            
        }
    }
    //MARK: - Search database

    private func searchInFirebase(forName: String) {
        
        showLoadingIndicator()
        
        searchBookInAlgolia(searchString: forName) { (itemIds) in
            downloadBooksForSearch(itemIds) { (books) in
                self.filteredBooks = books
               // self.myCollectionView.reloadData()
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
    
    private func disableAddBookButton(){
        //"wpr4nAyfkASGUqTp3lve1OoDsDU2"  -> admin userId who only can add items
        if Auth.auth().currentUser?.uid == "wpr4nAyfkASGUqTp3lve1OoDsDU2" {
            addBookOutlet.isEnabled = true
        }else{
            addBookOutlet.isEnabled = false
        }
    }
}
extension SeeAllBooksViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (isSearching) {
            return  filteredBooks.count
           }
           else {
            return booksArray.count
           }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BooksCollectionViewCell.self) , for: indexPath) as? BooksCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 2
        cell.contentView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        
        if isSearching {
            cell.bookNameLabel.text = filteredBooks[indexPath.row].bookName
        }else{
            cell.bookNameLabel.text = booksArray[indexPath.row].bookName
            
            if booksArray[indexPath.row].imageLinks.count > 0 {
                downloadImagesFromFirebase(imageUrls: [booksArray[indexPath.row].imageLinks.first!]) { (images) in
                    DispatchQueue.main.async {
                        cell.bookImageView.image = images.first as? UIImage
                    }
                }
            }
        }
       
        return cell
    }
   
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        guard let bookDetailsViewController = self.storyboard?.instantiateViewController(identifier: String(describing: BookDetailsViewController.self)) as? BookDetailsViewController else {
            return
        }
        bookDetailsViewController.book = booksArray[indexPath.row]
        self.present(bookDetailsViewController, animated: true, completion: nil)
    }
}
extension SeeAllBooksViewController: UICollectionViewDelegateFlowLayout {
    
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

extension SeeAllBooksViewController: UISearchBarDelegate{
    
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
       

