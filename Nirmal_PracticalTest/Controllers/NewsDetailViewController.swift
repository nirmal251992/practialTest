//
//  NewsDetailViewController.swift
//  Nirmal_PracticalTest
//
//  Created by cdp on 24/07/21.
//

import UIKit

class NewsDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var article_ImageView: UIImageView!
    
    var articlDetail : Articles?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = articlDetail?.title ?? ""
        descriptionLabel.text = articlDetail?.description ?? ""
        authorLabel.text = articlDetail?.author ?? ""
        urlLabel.text = articlDetail?.url ?? ""
        
        if let articleDate = articlDetail?.publishedAt {
            dateLabel.text = String.dateconversion(oldFormateDate: articleDate)
        }
        if let imageString = articlDetail?.urlToImage {
            let imageUrl = URL(string: imageString)!
            UIImage.loadFrom(url: imageUrl) { image in
                DispatchQueue.main.async {
                    self.article_ImageView.image = image
                    self.article_ImageView.contentMode = .scaleAspectFill
                }
            }
        }
    }
}
