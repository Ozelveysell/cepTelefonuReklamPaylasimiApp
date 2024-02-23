
import UIKit

class MarkaTableViewCell: UITableViewCell {

    let markaLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
         
        // ImageView'i hücreye ekle
        addSubview(logoImageView)
        logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Label'ı hücreye ekle
        addSubview(markaLabel)
        markaLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        markaLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        markaLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        markaLabel.trailingAnchor.constraint(equalTo: logoImageView.leadingAnchor, constant: -16).isActive = true

     }
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        // Burada gerekli başlangıç ayarlarını yapabilirsiniz
    }

}
