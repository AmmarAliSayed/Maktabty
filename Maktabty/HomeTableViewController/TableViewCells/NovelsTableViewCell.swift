//
//  NovelsTableViewCell.swift
//  Maktabty
//
//  Created by Macbook on 04/05/2021.
//

import UIKit

protocol NovelsCellDelegate: class {
    func selectedNovel(novel: Novel)
}
class NovelsTableViewCell: UITableViewCell {
    //MARK: - Vars
    var novelsArray : [Novel] = []
    weak var delegate: NovelsCellDelegate?
    
    @IBOutlet weak var NovelsCollectionView: UICollectionView!{
        didSet{
            NovelsCollectionView.delegate = self
            NovelsCollectionView.dataSource = self
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
        retrieveNovelsFromFirebase { (novelsArr) in
            self.novelsArray = novelsArr
            self.NovelsCollectionView.reloadData()
            
        }
    }
}
extension NovelsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return novelsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = NovelsCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: NovelsCollectionViewCell.self) , for: indexPath) as? NovelsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 2
        cell.contentView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        cell.novelNameLabel.text = novelsArray[indexPath.row].novelName
        
        if novelsArray[indexPath.row].imageLinks.count > 0 {
            downloadImagesFromFirebase(imageUrls: [novelsArray[indexPath.row].imageLinks.first!]) { (images) in
                DispatchQueue.main.async {
                    cell.novelImageView.image = images.first as? UIImage
                }
            }
        }else{
           // cell.bookImageView.image =  UIImage(named: "mainBook")
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
       self.delegate?.selectedNovel(novel: novelsArray[indexPath.row])
   }
}
