//
//  KeptArticleViewController.swift
//  NewsReader
//
//  Created by  Yujiro Saito on 2017/10/29.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import RealmSwift
import AlamofireImage

class KeptArticleViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //Outlet
    @IBOutlet weak var keptArticleTable: UITableView!
    
    //Property
    var selectedArticleUrl = String()
    var selectedArticleTitle = String()
    var selectedArticleImageURL = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Tableview setting
        self.keptArticleTable.delegate = self
        self.keptArticleTable.dataSource = self
        
        self.keptArticleTable.reloadData()
    }

   
    //Tableview methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleModelData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.keptArticleTable.dequeueReusableCell(withIdentifier: "KeptCell", for: indexPath) as? KeptArticleTableViewCell
        
        cell?.articleImage.image = nil
        
        //Cell setting
        cell?.articleTitle.text = articleModelData[indexPath.row].title
        cell?.articleImage.af_setImage(withURL: URL(string: articleModelData[indexPath.row].imageURL)!)
        
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Webview Controllerに遷移
        self.selectedArticleTitle = articleModelData[indexPath.row].title
        self.selectedArticleUrl = articleModelData[indexPath.row].url
        self.selectedArticleImageURL = articleModelData[indexPath.row].imageURL
        
        performSegue(withIdentifier: "Webviewer", sender: nil)
    }
    
    //WebView　Controllerに必要なデータを準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Webviewer" {
            
            let webviewVC = (segue.destination as? WebViewViewController)!
            //選択した記事のURLを渡す
            webviewVC.articleURL = self.selectedArticleUrl
            webviewVC.articleTitle = self.selectedArticleTitle
            webviewVC.articleImageURL = self.selectedArticleImageURL
        }
        
    }
    
    

}
