//
//  NewsDetailViewController.swift
//  Nirmal_PracticalTest
//
//  Created by cdp on 24/07/21.
//

import UIKit

class NewsDetailViewController: UIViewController,UIScrollViewDelegate,ZoomingDelegate {
    func pinchZoomHandlerStartPinching() {
        
    }
    
    func pinchZoomHandlerEndPinching() {
        
    }
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var article_ImageView: EEZoomableImageView! {
        didSet {
            article_ImageView.minZoomScale = 0.5
            article_ImageView.maxZoomScale = 3.0
            article_ImageView.resetAnimationDuration = 0.5
            article_ImageView.zoomDelegate = self
        }
    }
    
    var articlDetail : NewsModel?
    let imageSize : CGFloat = 200
    let pinchgesture = UIPinchGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = articlDetail?.title ?? ""
        descriptionLabel.text = articlDetail?.desc ?? ""
        authorLabel.text = articlDetail?.author ?? ""
        urlLabel.text = articlDetail?.url ?? ""
        
        if let articleDate = articlDetail?.date {
            dateLabel.text = String.dateconversion(oldFormateDate: articleDate)
        }
        if let imageString = articlDetail?.imageurl {
            let imageUrl = URL(string: imageString)!
            UIImage.loadFrom(url: imageUrl) { image in
                DispatchQueue.main.async {
                    self.article_ImageView.image = image
                    self.article_ImageView.contentMode = .scaleAspectFill
                }
            }
        }
        article_ImageView.isUserInteractionEnabled = true
        urlLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapUrl(_:))))
        //article_ImageView.addGestureRecognizer(pinchgesture)
        //pinchgesture.addTarget(self, action: #selector(didPinch(_:)))
    }
    @objc func didTapUrl(_ gesture: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "WebViewViewController") as! WebViewViewController
        vc.webUrl = urlLabel.text
        self.navigationController?.pushViewController(vc,
                                                      animated: true)
    }
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//       return self.article_ImageView
//    }
}
extension NewsDetailViewController {
    
     @objc private func didPinch(_ gesture:UIPinchGestureRecognizer) {
        
        guard let gestureview = pinchgesture.view else {
            return
        }
        gestureview.transform = gestureview.transform.scaledBy(x: pinchgesture.scale, y: pinchgesture.scale)
        pinchgesture.scale = 1
    }
}
