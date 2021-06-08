//
//  ItemTableViewCell.swift
//  Maktabty
//
//  Created by Macbook on 25/05/2021.
//

import UIKit

class BasketItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
