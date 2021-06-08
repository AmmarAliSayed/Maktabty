//
//  BooksTableViewCell.swift
//  Maktabty
//
//  Created by Macbook on 04/05/2021.
//

import UIKit

protocol BooksCellDelegate: class {
    func selectedBook(book: Book)
}

class BooksTableViewCell: UITableViewCell {

    var booksArray : [Book] = []
    weak var delegate: BooksCellDelegate?
    
    @IBOutlet weak var BooksCollectionView: UICollectionView!{
        didSet{
            BooksCollectionView.delegate = self
            BooksCollectionView.dataSource = self
            loadItems()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    //MARK: - Load Books from firebase
    
    private func loadItems() {
        retrieveBooksFromFirebase { (booksArr) in
            self.booksArray = booksArr
            self.BooksCollectionView.reloadData()
            
        }
    }
    
    
}
extension BooksTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return booksArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = BooksCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BooksCollectionViewCell.self) , for: indexPath) as? BooksCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 2
        cell.contentView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        cell.bookNameLabel.text = booksArray[indexPath.row].bookName
        
        if booksArray[indexPath.row].imageLinks.count > 0 {
            downloadImagesFromFirebase(imageUrls: [booksArray[indexPath.row].imageLinks.first!]) { (images) in
                DispatchQueue.main.async {
                    cell.bookImageView.image = images.first as? UIImage
                }
            }
        }else{
           // cell.bookImageView.image =  UIImage(named: "mainBook")
        }
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        self.delegate?.selectedBook(book: booksArray[indexPath.row])
    }
}
