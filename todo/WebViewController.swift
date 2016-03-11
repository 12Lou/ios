//
//  WebViewController.swift
//  todo
//
//  Created by 子空 on 16/2/29.
//  Copyright © 2016年 子空. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, UIWebViewDelegate, WKUIDelegate {
    
//    @IBOutlet weak var web: UIWebView!
    // 试图加载完毕
    @IBOutlet weak var myWeb: UIWebView!
    var myWK: WKWebView!
    var loading = false
    
    @IBOutlet weak var reloadStop: UIButton!
    @IBOutlet weak var urlText: UITextField!
    
    let refreshControl = UIRefreshControl()
    var refreshing = false {
        didSet{
            if !refreshing{
                self.refreshControl.endRefreshing()
            }
        }
    }
//    let uurl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myWeb.delegate = self
        
//        loadTo("http://www.baidu.com")
        loadLocal()
        
        self.refreshControl.addTarget(self, action: "refreshWebView", forControlEvents: UIControlEvents.ValueChanged)
        self.myWeb.scrollView.addSubview(refreshControl)
        
//        useWK()
        
    }
    
    func useWK(){
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        //Initialise javascript file with user content controller and configuration
        let configuration = WKWebViewConfiguration()
//        let scriptURL =    NSBundle.mainBundle().pathForResource("Your File Name", ofType: "js")
        let scriptContent = "window.app = {name:'宋小帆'}"
//        do {
//            scriptContent = try String(contentsOfFile: scriptURL!, encoding: NSUTF8StringEncoding)
//        } catch{
//            print("Cannot Load File")
//        }
        let script = WKUserScript(source: scriptContent, injectionTime: .AtDocumentStart, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(script)
        configuration.preferences = preferences
        //Create WebView instance
        myWK = WKWebView(frame: CGRectMake(0,64.0, self.view.frame.size.width, self.view.frame.size.height), configuration: configuration)
        view.addSubview(myWK)
        //Finally load the url
        
//        let url = NSURL(string:"your URL")
//        let urlRequest = NSURLRequest(URL: url!)
        
        let localfilePath = NSBundle.mainBundle().URLForResource("home", withExtension: "html");
        let myRequest = NSURLRequest(URL: localfilePath!);
        myWK.loadRequest(myRequest)
    }
    
    func refreshWebView(){
        print("下拉刷新开始")
        refreshing = true
        myWeb.reload()
    }
    // 收到内存警告？
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadTo(url: String){
        let nsUrl = NSURL(string: url)
        let requestObj = NSURLRequest(URL: nsUrl! )
        
        myWeb.loadRequest( requestObj )
    }
    
    func loadLocal(){
        let localfilePath = NSBundle.mainBundle().URLForResource("home", withExtension: "html");
        let myRequest = NSURLRequest(URL: localfilePath!);
        myWeb.loadRequest(myRequest);
    }
   
    
    // 页面开始加载
    func webViewDidStartLoad(webView: UIWebView){
        loading = true
        refreshing = false
        // 修改button的title， forState这个参数表示显示状态 UIControlState.Normal/highlight等
        reloadStop.setTitle("stop", forState: UIControlState.Normal)
        print("页面开始加载") 
    }
    
    // 页面加载完成
    func webViewDidFinishLoad(webView: UIWebView){
        loading = false
        let title = webView.stringByEvaluatingJavaScriptFromString("document.title")
        reloadStop.setTitle("reload", forState: UIControlState.Normal)
        
        print("页面加载完毕",title!)
        // 修改导航栏标题
        navigationItem.title = title!
        urlText.text = myWeb.request?.URL?.absoluteString
        
        
        print(self.myWeb.stringByEvaluatingJavaScriptFromString("navigator.userAgent")!)
        
        let a = "window.app = {version:0.1, appname: '嘿嘿', time: new Date().getTime()}; pubsub.pub('appready',window.app);"
        webView.stringByEvaluatingJavaScriptFromString(a)
        print( webView.stringByEvaluatingJavaScriptFromString("app.appname") )
    }
    
    // 页面加载失败
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?){
        loading = false
        reloadStop.setTitle("reload", forState: UIControlState.Normal)
        print("页面加载失败")
    }
    
    //     这个是？开始请求地址，在这里可以拦截请求，转换请求地址等
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        // relativePath相对路径
        print("拦截请求：",request.mainDocumentURL?.relativePath, request.mainDocumentURL?.relativeString )
        return true
    }
    @IBAction func prevTap(sender: AnyObject) {
        // 返回上一页
        myWeb.goBack()
    }
    
    @IBAction func nextTap(sender: AnyObject) {
        // 返回下一页
        myWeb.goForward()
    }
    
    @IBAction func reloadTap(sender: AnyObject) {
        if loading{
            // 停止加载
            myWeb.stopLoading()
        }else{
            // 刷新页面
            myWeb.reload()
        }
    }
    
    // 输入链接，页面跳转
    @IBAction func goTap(sender: AnyObject) {
        let url = urlText.text
        loadTo(url!)
    }
    func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: (() -> Void)) {
        
    }
    
}