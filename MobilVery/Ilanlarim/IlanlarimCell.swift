//
//  IlanlarimCell.swift
//  MobilVery
//
//  Created by veysel on 18.09.2023.
//

import UIKit

class IlanlarimCell: UITableViewCell {

    @IBOutlet weak var imageView2: UIImageView!
    
    @IBOutlet weak var baslikLabel: UILabel!
    
    @IBOutlet weak var konumLabel: UILabel!
    
    @IBOutlet weak var markaModelLabel: UILabel!
    
    @IBOutlet weak var fiyatLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
