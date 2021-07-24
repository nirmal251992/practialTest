//
//  NewsListViewController.swift
//  Nirmal_PracticalTest
//
//  Created by cdp on 24/07/21.
//

import UIKit
import CoreData

class NewsListViewController: UIViewController,NewsCellDelegate {
    
    @IBOutlet weak var table_News_List: UITableView!
    
    var articles : [NewsModel]?
    var results:[Articles]? {
         didSet {
             // Remove all Previous Records
             DatabaseManager.deleteAllNews()
             // Add the new spots to Core Data Context
            self.addNewsToCoreData(self.results!)
             // Save them to Core Data
             DatabaseManager.saveContext()
             // Reload the tableView
            self.reloadTableView()
         }
     }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        table_News_List.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        loadNewsList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.articles = DatabaseManager.getAllNews()
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
                        //self.results = decodedResponse.articles
                        if let ar = decodedResponse.articles {
                            if ar.count > 0 {
                                self.addNewsToCoreData(ar)
                                self.table_News_List.reloadData()
                            }
                        }
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    func addNewsToCoreData( _ articles: [Articles]) {
        
        for article in articles {
            let entity = NSEntityDescription.entity(forEntityName: "NewsModel", in: DatabaseManager.getContext())
            let newShow = NSManagedObject(entity: entity!, insertInto: DatabaseManager.getContext())
            let uuid = UUID()
            newShow.setValue(article.author, forKey: "author")
            newShow.setValue(article.publishedAt, forKey: "date")
            newShow.setValue(article.title, forKey: "title")
            newShow.setValue(article.urlToImage, forKey: "imageurl")
            newShow.setValue(article.url, forKey: "url")
            newShow.setValue(article.description, forKey: "desc")
            newShow.setValue(uuid.uuidString, forKey: "uuid")
        }
        
    }
    func passUrl(url: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "WebViewViewController") as! WebViewViewController
        vc.webUrl = url
        self.navigationController?.pushViewController(vc,
                                                      animated: true)
    }
    func reloadTableView() {
        DispatchQueue.main.async {
            self.table_News_List.reloadData()
        }
    }

}

extension NewsListViewController: UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DatabaseManager.getAllNews().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newsCell = table_News_List.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        newsCell.urlLabel.tag = indexPath.row
        newsCell.delegate = self
       
        self.articles = DatabaseManager.getAllNews()
        if let article = articles {
            if article.count != 0 {
                if let name = article[indexPath.row].title {
                    newsCell.titleLabel.text = name
                }
                if let articleDate = article[indexPath.row].date {
                    newsCell.dateLabel.text = String.dateconversion(oldFormateDate: articleDate)
                }
                if let authorName = article[indexPath.row].author {
                    newsCell.authorLabel.text = authorName
                }
                if let articleUrl = article[indexPath.row].url {
                    newsCell.urlLabel.setTitle(articleUrl, for: .normal)
                }
                if let imageString = article[indexPath.row].imageurl {
                    let imageUrl = URL(string: imageString)!
                    UIImage.loadFrom(url: imageUrl) { image in
                        DispatchQueue.main.async {
                            newsCell.news_imageview.image = image
                            newsCell.news_imageview.contentMode = .scaleAspectFill
                        }
                    }
                }
            } else {
                print("No shows bros")
            }
        }
      

//        if let title = results?[indexPath.row].title {
//            newsCell.titleLabel.text = title
//        }
//        if let articleDate = results?[indexPath.row].publishedAt {
//            newsCell.dateLabel.text = String.dateconversion(oldFormateDate: articleDate)
//        }
//        if let authorName = results?[indexPath.row].author {
//            newsCell.authorLabel.text = authorName
//        }
//        if let articleUrl = results?[indexPath.row].url {
//            newsCell.urlLabel.setTitle(articleUrl, for: .normal)
//        }
//        if let imageString = results?[indexPath.row].urlToImage {
//            let imageUrl = URL(string: imageString)!
//            UIImage.loadFrom(url: imageUrl) { image in
//                DispatchQueue.main.async {
//                    newsCell.news_imageview.image = image
//                    newsCell.news_imageview.contentMode = .scaleAspectFill
//                }
//            }
//        }
        return newsCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "NewsDetailViewController") as! NewsDetailViewController
        vc.articlDetail = articles?[indexPath.row]
        self.navigationController?.pushViewController(vc,
                                                    animated: true)
    }
}
