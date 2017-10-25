//
//  ViewController.swift
//  NewsReader
//
//  Created by  Yujiro Saito on 2017/10/25.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //Outlet
    @IBOutlet weak var newsTable: UITableView!
    
    //Properties
    var newsArticleArray: [ArticleModel] = []
    typealias JsonFormat = [String : Any]
    let requestUrl = "https://newsapi.org/v1/articles?source=bbc-news&sortBy=top&apiKey=cb6bd682f63c418e91691a265d1962c1"
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Table setting
        self.newsTable.delegate = self
        self.newsTable.dataSource = self
        self.callAlamofire(url: requestUrl)
        
    }
    
    //Alamofire(Request and Response)
    func callAlamofire(url: String) {
        Alamofire.request(url).response { (response) in
            self.parseJsonData(JsonData: response.data!)
        }
    }
    
    //Jsonデータを取得
    func parseJsonData(JsonData: Data) {
        self.newsArticleArray = [ArticleModel]()
        
        do {
            //Convert to Json
            let readableJson = try JSONSerialization.jsonObject(with: JsonData, options: .mutableContainers) as! JsonFormat
            
            
            //Fetch json data
            if let articles = readableJson["articles"] as? [JsonFormat] {
                
                for a in 0..<articles.count {
                    
                    //一つの記事
                   let singleArticle = articles[a]
                    //記事のデータStruct
                    var articleModel = ArticleModel()
                    
                    if let articleTitle = singleArticle["title"] as? String, let articleUrl = singleArticle["url"] as? String, let articleImageUrl = singleArticle["urlToImage"] as? String {
                        
                        
                        articleModel.articleTitle = articleTitle
                        articleModel.articleUrl = articleUrl
                        articleModel.articleImageURL = articleImageUrl
                        
                    }
                    
                    self.newsArticleArray.append(articleModel)
                    
                    
                }
                
                
                
                
            }
            
            
            DispatchQueue.main.async {
                self.newsTable.reloadData()
            }
            
            
        } catch {
            print(error)
        }
        
        
    }
    
    
    
    //TableView methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsArticleArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Cell setting
        let cell = self.newsTable.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsTableViewCell
        
        //画像を読み込むまでは何も入れない
        cell?.newsCellImage.image = nil
        
        //News情報をセルに載せる
        cell?.newsCellTItleLabel.text = self.newsArticleArray[indexPath.row].articleTitle
        cell?.newsCellImage.af_setImage(withURL: URL(string: self.newsArticleArray[indexPath.row].articleImageURL!)!)
        
        
        
        return cell!
    }
    
    

   

}

