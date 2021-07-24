//
//  NewsCell.swift
//  Nirmal_PracticalTest
//
//  Created by cdp on 24/07/21.
//

import UIKit

protocol NewsCellDelegate {
    func passUrl(url:String)
}


class NewsCell: UITableViewCell {

    @IBOutlet weak var news_imageview: UIImageView!
    @IBOutlet weak var urlLabel: UIButton!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate : NewsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTapUrl(_ sender: UIButton) {

        if let urlText = urlLabel.titleLabel?.text{
            delegate?.passUrl(url: urlText)
         
        }
    }
}
