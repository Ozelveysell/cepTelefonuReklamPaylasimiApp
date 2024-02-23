

import UIKit

class MesajlarTableViewCell: UITableViewCell {

    @IBOutlet weak var tarihLabel: UILabel!
    
    @IBOutlet weak var adSoyadLabel: UILabel!
    
    @IBOutlet weak var icerikLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
