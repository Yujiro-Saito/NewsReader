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
import SafariServices


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //Outlet
    @IBOutlet weak var newsTable: UITableView!
    
    //Properties
    var newsArticleArray: [ArticleModel] = []
    typealias JsonFormat = [String : Any]
    let bbcURL = "https://newsapi.org/v1/articles?source=bbc-news&sortBy=top&apiKey=cb6bd682f63c418e91691a265d1962c1"
    let bloombergUrl = "https://newsapi.org/v1/articles?source=bloomberg&sortBy=top&apiKey=cb6bd682f63c418e91691a265d1962c1"
    let nationalURL = "https://newsapi.org/v1/articles?source=national-geographic&sortBy=top&apiKey=cb6bd682f63c418e91691a265d1962c1"
    let mashableURL = "https://newsapi.org/v1/articles?source=mashable&sortBy=top&apiKey=cb6bd682f63c418e91691a265d1962c1"
    var selectedArticleUrl = String()
    var selectedArticleTitle = String()
    var selectedArticleImageURL = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Table setting
        self.newsTable.delegate = self
        self.newsTable.dataSource = self
        self.callAlamofire(url: mashableURL)
        self.callAlamofire(url: bloombergUrl)
        self.callAlamofire(url: nationalURL)
        self.callAlamofire(url: bbcURL)
        
    }
    
    //Alamofire(Request and Response)
    func callAlamofire(url: String) {
        self.newsArticleArray = [ArticleModel]()
        Alamofire.request(url).response { (response) in
            self.parseJsonData(JsonData: response.data!)
        }
    }
    
    //Jsonデータを取得
    func parseJsonData(JsonData: Data) {
        
        do {
            //Convert to Json
            let readableJson = try JSONSerialization.jsonObject(with: JsonData, options: .mutableContainers) as! JsonFormat
            
            
            //Fetch json data(Detect article details)
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
                        
                        //URLからニュースサイト名を判別(セルにソースサイト名を載せるため)
                        let isUrlFrom = articleUrl
                        if (isUrlFrom.contains("bbc")){
                            //BBC
                            articleModel.articleSource = "BBC"
                        } else if (isUrlFrom.contains("bloomberg")) {
                            //bloomberg
                            articleModel.articleSource = "bloomberg"
                        } else if (isUrlFrom.contains("mashable")) {
                            //mashable
                            articleModel.articleSource = "mashable"
                        } else if (isUrlFrom.contains("ationalgeographic")) {
                            //nationalgeographic
                            articleModel.articleSource = "Nationalgeographic"
                        }
                        
                        
                        
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
        cell?.newsCellSourceNameLabel.text = self.newsArticleArray[indexPath.row].articleSource
        
        
        return cell!
    }
    
    
    //TableViewタップ時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedArticleUrl = self.newsArticleArray[indexPath.row].articleUrl!
        self.selectedArticleTitle = self.newsArticleArray[indexPath.row].articleTitle!
        self.selectedArticleImageURL = self.newsArticleArray[indexPath.row].articleImageURL!
        //Webview Controllerに遷移
        performSegue(withIdentifier: "Webview", sender: nil)
    }
    
    //WebView　Controllerに必要なデータを準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Webview" {
            
            let webviewVC = (segue.destination as? WebViewViewController)!
            //選択した記事のURLを渡す
            webviewVC.articleURL = self.selectedArticleUrl
            webviewVC.articleTitle = self.selectedArticleTitle
            webviewVC.articleImageURL = self.selectedArticleImageURL
        }
        
    }
    
}

