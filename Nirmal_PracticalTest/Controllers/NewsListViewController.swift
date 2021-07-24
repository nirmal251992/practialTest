//
//  NewsListViewController.swift
//  Nirmal_PracticalTest
//
//  Created by cdp on 24/07/21.
//

import UIKit

class NewsListViewController: UIViewController {
    
    @IBOutlet weak var table_News_List: UITableView!
    
    var results : News?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table_News_List.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
    }
    /*  NewsList Api Func */
    func loadNewsList() {
        guard let url = URL(string: newsurl) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(News.self, from: data) {
                    DispatchQueue.main.async {
                        self.results = decodedResponse
                        self.table_News_List.reloadData()
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}

extension NewsListViewController: UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newsCell = table_News_List.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        
        if let title = results?.articles?[indexPath.row].title {
            newsCell.titleLabel.text = title
        }
        if let articleDate = results?.articles?[indexPath.row].publishedAt {
            newsCell.dateLabel.text = articleDate
        }
        if let authorName = results?.articles?[indexPath.row].author {
            newsCell.authorLabel.text = authorName
        }
        if let imageString = results?.articles?[indexPath.row].urlToImage {
            let imageUrl = URL(string: imageString)!
            UIImage.loadFrom(url: imageUrl) { image in
                DispatchQueue.main.async {
                    newsCell.news_imageview.image = image
                }
            }
        }
        return newsCell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
