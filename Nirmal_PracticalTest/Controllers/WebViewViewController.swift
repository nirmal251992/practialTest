//
//  WebViewViewController.swift
//  Nirmal_PracticalTest
//
//  Created by cdp on 24/07/21.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController,WKNavigationDelegate {
    
    var webView : WKWebView!
    var webUrl : String!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let url = URL(string: webUrl)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

}
