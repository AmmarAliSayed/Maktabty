//
//  BasketBookNovelTableViewCell.swift
//  Maktabty
//
//  Created by Macbook on 25/05/2021.
//

import UIKit

class BasketBookNovelTableViewCell: UITableViewCell {

    @IBOutlet weak var bookNovelView: UIView!
    @IBOutlet weak var bookNovelPriceLabel: UILabel!
    @IBOutlet weak var bookNovelAutherLabel: UILabel!
    @IBOutlet weak var bookNovelNameLabel: UILabel!
    @IBOutlet weak var bookNovelImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
