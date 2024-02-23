//
//  AcilSatiliklarCell.swift
//  MobilVery
//
//  Created by veysel on 17.09.2023.
//

import UIKit

class AcilSatiliklarCell: UITableViewCell {

    @IBOutlet weak var anaSayfaImageView: UIImageView!
    
    @IBOutlet weak var baslikLabel: UILabel!
    
    @IBOutlet weak var konumLabel: UILabel!
    
    @IBOutlet weak var markaModelLabel: UILabel!
    
    
    @IBOutlet weak var fiyatLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        baslikLabel.numberOfLines = 2
        baslikLabel.font = .boldSystemFont(ofSize: 18)
       
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
