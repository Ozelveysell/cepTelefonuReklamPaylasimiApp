//
//  IlanlarimOzellikCell.swift
//  MobilVery
//
//  Created by veysel on 18.09.2023.
//

import UIKit

class IlanlarimOzellikCell: UITableViewCell {

    @IBOutlet weak var ozellikLabel: UILabel!
    
    @IBOutlet weak var secilenOzellikLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
