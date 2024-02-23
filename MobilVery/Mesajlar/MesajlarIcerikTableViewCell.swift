

import UIKit

class MesajlarIcerikTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mesajSaatiLabel: UILabel!
    
    @IBOutlet weak var mesajLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
