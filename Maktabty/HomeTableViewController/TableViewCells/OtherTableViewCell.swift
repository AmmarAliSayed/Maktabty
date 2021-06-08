//
//  OtherTableViewCell.swift
//  Maktabty
//
//  Created by Macbook on 05/05/2021.
//

import UIKit

protocol ItemsCellDelegate: class {
    func selectedItem(item: Item)
}

class OtherTableViewCell: UITableViewCell {
    
    //MARK: - Vars
    var itemsArray : [Item] = []
    weak var delegate: ItemsCellDelegate?
    
    @IBOutlet weak var otherCollectionView: UICollectionView!{
        didSet{
            otherCollectionView.delegate = self
            otherCollectionView.dataSource = self
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
    //MARK: - Load Novels from firebase
    
    private func loadItems() {
        retrieveItemsFromFirebase { (items) in
            self.itemsArray = items
            self.otherCollectionView.reloadData()
        }
    }
}
extension OtherTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = otherCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: OtherCollectionViewCell.self) , for: indexPath) as? OtherCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 2
        cell.contentView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        cell.itemLabel.text = itemsArray[indexPath.row].itemName
        
        if itemsArray[indexPath.row].imageLinks.count > 0 {
            downloadImagesFromFirebase(imageUrls: [itemsArray[indexPath.row].imageLinks.first!]) { (images) in
                DispatchQueue.main.async {
                    cell.itemImageView.image = images.first as? UIImage
                }
            }
        }else{
           // cell.bookImageView.image =  UIImage(named: "mainBook")
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        self.delegate?.selectedItem(item: itemsArray[indexPath.row])
   }
}
