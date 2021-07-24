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
        authorLabel.text = articlDetail?.author ?? ""
        dateLabel.text = articlDetail?.publishedAt ?? ""
        urlLabel.text = articlDetail?.url ?? ""
        descriptionLabel.text = articlDetail?.description ?? ""
    }

}
