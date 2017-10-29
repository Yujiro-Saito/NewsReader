//
//  WebViewViewController.swift
//  NewsReader
//
//  Created by  Yujiro Saito on 2017/10/29.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit
import RealmSwift



//保存記事用のクラス
internal class ArticleData: Object {
    @objc dynamic var title = String()
    @objc dynamic var url = String()
    @objc dynamic var imageURL = String()
}


class WebViewViewController: UIViewController,UIWebViewDelegate {

    //受け取り用のデータ(タイトル,URL,画像URL)
    var articleURL = String()
    var articleTitle = String()
    var articleImageURL = String()
    
    //Outlet
    @IBOutlet weak var webViewer: UIWebView!
    
    //Realm
    let realm = try! Realm()
    
    var articleModelData: Results<ArticleData> {
        
        get {
            return realm.objects(ArticleData.self)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.realm.objects(ArticleData.self))
        //Webview Delegate設定
        self.webViewer.delegate = self
        //記事の読み込み
        let url: URL = URL(string: self.articleURL)!
        let request: URLRequest = URLRequest(url: url)
        self.webViewer.loadRequest(request)

    }
    
    //Showing an indicator while loading
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    //Stop indicator when loaded
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

   //記事の保存
    @IBAction func saveArticle(_ sender: Any) {
        //保存記事の情報を追加(タイトル、URL、画像のURL)
        let keptArticle = ArticleData()
        keptArticle.title = self.articleTitle
        keptArticle.url = self.articleURL
        keptArticle.imageURL = self.articleImageURL
        
        //Realm DBに保存
        try! self.realm.write {
            self.realm.add(keptArticle)
            print("保存を完了しました")
            let alert: UIAlertController = UIAlertController(title: "保存しました", message: nil, preferredStyle:  UIAlertControllerStyle.alert)
            
            // OKボタン
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                (action: UIAlertAction!) -> Void in
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    //記事を閉じる
    @IBAction func closeArticle(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    
}
