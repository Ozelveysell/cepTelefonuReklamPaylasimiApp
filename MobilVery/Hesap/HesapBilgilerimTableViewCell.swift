//
//  HesapBilgilerimTableViewCell.swift
//  MobilVery
//
//  Created by veysel on 12.10.2023.
//

import UIKit

class HesapBilgilerimTableViewCell: UITableViewCell {

    @IBOutlet weak var ozellikLabel: UILabel!
    
    @IBOutlet weak var kisiselOzellikText: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
