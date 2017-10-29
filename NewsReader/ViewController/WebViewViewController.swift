//
//  WebViewViewController.swift
//  NewsReader
//
//  Created by  Yujiro Saito on 2017/10/29.
//  Copyright © 2017年 yujiro_saito. All rights reserved.
//

import UIKit

//キープ記事用の配列
internal var keptArticleTitle: [String] = []
internal var keptArticleURL: [String] = []
internal var keptArticleImageURL: [String] = []


class WebViewViewController: UIViewController,UIWebViewDelegate {

    //受け取り用のデータ
    var articleURL = String()
    
    //Outlet
    @IBOutlet weak var webViewer: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
    }
    
    
    //記事を閉じる
    @IBAction func closeArticle(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
