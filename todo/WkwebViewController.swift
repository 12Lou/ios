//
//  WkwebViewController.swift
//  todo
//
//  Created by 子空 on 16/3/7.
//  Copyright © 2016年 子空. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON

// 使用 WKWebView
// 好处：性能更高，可添加本地的js，并且是无痛添加
// 记录scrollTop，这是必要的，当返回【本次历史页】的时候，可记录浏览位置
class WkwebViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    
    var wkweb: WKWebView!
    var toolBarView: UIView!
    var toolBarViewHidden = true
    
    var refreshControl = UIRefreshControl()
    var reload: UIButton!
    var urlInput: UITextField!
    let TOOLBAR_HEIGHT = 30
    var TOOBAR_TOP = 0
    var refresh = false{
        didSet{
            if refresh == false{
                refreshControl.endRefreshing()
            }else{
                refreshControl.beginRefreshing()
                wkweb.reload()
            }
        }
    }
    
    var tips: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加一个WKWebView
        TOOBAR_TOP = Int(self.view.frame.size.height) - TOOLBAR_HEIGHT
        addWKWeb()
        wkweb.navigationDelegate = self
        
        // 添加下拉刷新
        self.refreshControl.addTarget(self, action: "refreshWebView", forControlEvents: UIControlEvents.ValueChanged)
        self.wkweb.scrollView.addSubview(refreshControl)
        
        // 监听WKWebView一些属性变化
        observeWkweb()
        
        // 添加工具栏
        addToolBar()
        
        // 右边按钮
        //  navigationItem.rightBarButtonItem.
        let rightButton = UIBarButtonItem(title: "···", style: UIBarButtonItemStyle.Done , target: self, action: "rightButtonAction")
        self.navigationItem.rightBarButtonItem = rightButton
        
        addLoadingView()
        
        // 添加tips
        addTips()
        
        // 进入某个链接
         loadToLocal("home", filetype: "html")
//        loadTo("http://www.baidu.com")
    }
    
    func rightButtonAction(){
        if toolBarViewHidden {
            self.wkweb.frame.size.height = self.view.frame.size.height - CGFloat(self.TOOLBAR_HEIGHT)
        }else{
            self.wkweb.frame.size.height = self.view.frame.size.height
        }
        UIView.animateWithDuration(0.3, animations: {
            print("y:",self.wkweb.frame.size.height)
            self.toolBarView.frame.origin.y = self.wkweb.frame.size.height
        }, completion: heihei )
        
        
    }
    
    func heihei(B: Bool){
        toolBarViewHidden = !toolBarViewHidden
        print("工具栏",toolBarViewHidden)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshWebView(){
        refresh = true
    }
    
    func addWKWeb(){
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        //Initialise javascript file with user content controller and configuration
        
        // 生成文件地址
        // let scriptURL = NSBundle.mainBundle().pathForResource("Your File Name", ofType: "js")
        let scriptContent = "window.app = {name:'嘿嘿'}"
        // 读取文件
        //  do {
        //      scriptContent = try String(contentsOfFile: scriptURL!, encoding: NSUTF8StringEncoding)
        //  } catch{
        //      print("Cannot Load File")
        //  }
        let script = WKUserScript(source: scriptContent, injectionTime: WKUserScriptInjectionTime.AtDocumentStart , forMainFrameOnly: true)
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.addUserScript(script)
        
        let sc = "window.webkit.messageHandlers.foo.postMessage({title: document.title });"
        let testscript = WKUserScript(source: sc, injectionTime: WKUserScriptInjectionTime.AtDocumentEnd, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(testscript)
        
        // 注册事件，监听从网页内传来的消息
        configuration.userContentController.addScriptMessageHandler(self, name: "foo")
        
//        configuration.preferencwkes = preferences
        
        let navHeight = self.navigationController?.navigationBar.frame.size.height
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        
        print("导航条高度", navHeight, self.view.frame.size.height , statusBarHeight)
        //Create WebView instance
//        let sheight = navHeight! + statusBarHeight
//        let wkwebHeight = self.view.frame.size.height - CGFloat(TOOLBAR_HEIGHT)
        wkweb = WKWebView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height ), configuration: configuration)
        
        wkweb.backgroundColor = UIColor(red: 200, green: 100, blue: 300, alpha: 1)
        
        view.addSubview(wkweb)
    }
    
    // 加载网络地址
    func loadTo(url: String){
        let nsUrl = NSURL(string: url)
        let requestObj = NSURLRequest(URL: nsUrl! )
        
        wkweb.loadRequest(requestObj)
    }
    
    // 加载本地地址
    func loadToLocal(filename: String , filetype: String?){
        let localfilePath = NSBundle.mainBundle().URLForResource( filename , withExtension: filetype);
        let requestObj = NSURLRequest(URL: localfilePath! )
        
        wkweb.loadRequest(requestObj)
    }
    
    // 添加工具栏
    func addToolBar(){
        let BTNWIDTH = 50
        
        toolBarView = UIView(frame: CGRect(x: 0, y: TOOBAR_TOP+TOOLBAR_HEIGHT, width: 375, height: TOOLBAR_HEIGHT))
//        canvas.backgroundColor = UIColor(red: 200/255, green: 100/255, blue: 30/255, alpha: 1)
        view.addSubview(toolBarView)
        
        // 向前
        let back = UIButton(frame: CGRect(x: 0, y: 0, width: BTNWIDTH, height: TOOLBAR_HEIGHT))
        back.setTitle("<-", forState: UIControlState.Normal )
        back.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        back.backgroundColor = UIColor(red: 100/255, green: 50/255, blue: 200/255, alpha: 0.3)
        back.layer.zPosition = 1
        
        back.addTarget(self, action: "goBack", forControlEvents: UIControlEvents.TouchUpInside )
        toolBarView.addSubview( back )
        
        // 向后
        let forward = UIButton(frame: CGRect(x: BTNWIDTH, y: 0, width: BTNWIDTH, height: TOOLBAR_HEIGHT))
        forward.setTitle("->", forState: UIControlState.Normal )
        forward.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        forward.backgroundColor = UIColor(red: 200/255, green: 50/255, blue: 100/255, alpha: 0.3)
        forward.layer.zPosition = 1
        
        forward.addTarget(self, action: "goForward", forControlEvents: UIControlEvents.TouchUpInside )
        toolBarView.addSubview( forward )
        
        // 刷新/停止
        reload = UIButton(frame: CGRect(x: BTNWIDTH*2, y: 0, width: BTNWIDTH, height: TOOLBAR_HEIGHT))
        reload.setTitle("×", forState: UIControlState.Normal )
        reload.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        reload.backgroundColor = UIColor(red: 250/255, green: 50/255, blue: 150/255, alpha: 0.3)
        reload.layer.zPosition = 1
        
        reload.addTarget(self, action: "stopOrReload", forControlEvents: UIControlEvents.TouchUpInside )
        toolBarView.addSubview( reload )
        
        // 添加地址输入框
        urlInput = UITextField(frame: CGRect(x: BTNWIDTH*3, y: 0, width: BTNWIDTH*2, height: TOOLBAR_HEIGHT) )
        urlInput.placeholder = "Enter text here"
        urlInput.font = UIFont.systemFontOfSize(15)
        urlInput.borderStyle = UITextBorderStyle.RoundedRect
        urlInput.autocorrectionType = UITextAutocorrectionType.No
        urlInput.keyboardType = UIKeyboardType.Default
        urlInput.returnKeyType = UIReturnKeyType.Done
        urlInput.clearButtonMode = UITextFieldViewMode.WhileEditing;
        urlInput.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        toolBarView.addSubview(urlInput)
        
        let go = UIButton(frame: CGRect(x: BTNWIDTH*5, y: 0, width: BTNWIDTH, height: TOOLBAR_HEIGHT))
        go.setTitle("Go", forState: UIControlState.Normal )
        go.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        go.backgroundColor = UIColor(red: 100/255, green: 50/255, blue: 200/255, alpha: 0.3)
        go.addTarget(self, action: "goWhere", forControlEvents: UIControlEvents.TouchUpInside )
        toolBarView.addSubview(go)
        
//        toolBarView.hidden = true
        
    }
    
    func goWhere(){
        let url = urlInput.text!
        loadTo(url)
    }
    
    func goBack(){
        wkweb.goBack()
    }
    
    func goForward(){
        wkweb.goForward()
    }
    
    var reloading = false {
        didSet{
            if reloading == false{
                reload.setTitle("◎", forState: UIControlState.Normal)
            }else{
                reload.setTitle("×", forState: UIControlState.Normal)
            }
        }
    }
    func stopOrReload(){
        if reloading == false{
            wkweb.reload()
        }else{
            wkweb.stopLoading()
        }
    }
    
    // 预备加载
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("开始加载···")
        print("请求地址", webView.URL)
        
        var allowNetWork: Bool = true
        if webView.URL == "http://www.baidu.com" {
            allowNetWork = false
        }else{
            allowNetWork = true
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = allowNetWork
        
    }
    // 加载中
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        print("加载中···")
        reloading = true
        navigationItem.title = "记载中···"
    }
    // 加载结束
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        refresh = false
        reloading = false
//  wkweb.evaluateJavaScript("document.title", completionHandler: <#T##((AnyObject?, NSError?) -> Void)?##((AnyObject?, NSError?) -> Void)?##(AnyObject?, NSError?) -> Void#>)
        wkweb.evaluateJavaScript("document.title", completionHandler: deal )
        //        print("加载完成···")
        //        navigationItem.title = "记载中···"
    // navigationItem.title = wkweb.string
    }
    
    
    func deal(msg: AnyObject?, error: NSError?){
        navigationItem.title = msg as? String
        print( "webview title:",wkweb.title )
    }
    // 即在失败
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        print("加载失败···")
    }
    
    // 处理收到window.webkit.messageHandlers发送来的消息
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage){
        
        print("got message: \(message.body)")
        
        let json = JSON(message.body)
        if let title = json["title"].string {
            navigationItem.title = title
        }
        
        if let tips = json["tips"].bool {
            if tips {
                if let title = json["title"].string {
                    setTipsTitle(title)
                }
                tipsHidden = false
            }
        }
    }
    
    
    // 其实navigationItem.title 应该是和 wkweb.title 同步的，因此要坚挺wkweb.title的变化
    // 这么做很爽啊
    //
    func observeWkweb(){
        // 监听WKWebView title的变化
        self.wkweb.addObserver(self, forKeyPath: "title", options: .New, context: nil)
        // 监听进度调皮变化
        self.wkweb.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        // 监听loading变化
        self.wkweb.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath=="title" {
            self.title = self.wkweb.title
            urlInput.text = self.wkweb.URL?.absoluteString
        }
    }
    
    var loadingView: UIView!
    var loadingViewMax = false{
        didSet{
            if loadingViewMax {
                UIView.animateWithDuration(1, animations: {
                    self.loadingView.bounds = CGRect(x: 150, y: 300, width: 100, height: 100)
                    self.loadingView.layer.cornerRadius = 50
                    self.loadingView.backgroundColor = UIColor(red: 180/255, green: 50/255, blue: 230/255, alpha: 0.2)
                })
            }else{
                UIView.animateWithDuration(1, animations: {
                    self.loadingView.bounds = CGRect(x: 150, y: 300, width: 50, height: 50)
                    self.loadingView.layer.cornerRadius = 25
                    self.loadingView.backgroundColor = UIColor(red: 100/255, green: 150/255, blue: 200/255, alpha: 1)
                })
            }
        }
    }
    // 加载中
    func addLoadingView(){
        loadingView = UIView(frame: CGRect(x: 150, y: 300, width: 50, height: 50))
        loadingView.backgroundColor = UIColor(red: 100/255, green: 150/255, blue: 200/255, alpha: 1)
        loadingView.layer.cornerRadius = 25
        loadingView.layer.masksToBounds = true
        loadingView.layer.borderWidth = 10
        loadingView.layer.borderColor = UIColor(red: 0/255, green: 0/255, blue: 200/255, alpha: 1).CGColor
        
        self.view.addSubview(loadingView)
        
         NSTimer.scheduledTimerWithTimeInterval( 2, target: self, selector: "loadingAnimation", userInfo: nil, repeats: true)
        
    }
    
    func loadingAnimation(){
        loadingViewMax = !loadingViewMax
    }
    
    var tipsHidden = true {
        didSet{
            if tipsHidden{
                tips.hidden = true
            }else{
                tips.layer.opacity = 1
                var t = CGAffineTransformIdentity
                t = CGAffineTransformScale(t, CGFloat(1), CGFloat(1))
                tips.transform = t
                tips.hidden = false
                NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "tipsHide", userInfo: nil, repeats: false)
            }
        }
    }
    func tipsHide(){
//        tipsHidden = true
        UIView.animateWithDuration(0.5, animations: {
            self.tips.layer.opacity = 0
            
//            var t = CATransform3D()
//            t = CATransform3DTranslate(t, CGFloat(100), CGFloat(300), CGFloat(0))
//            t = CATransform3DRotate(t, CGFloat(M_PI_4), CGFloat(0), CGFloat(0), CGFloat(0))
//            t = CATransform3DScale(t, CGFloat(2), CGFloat(2), CGFloat(1))
//            self.tips.layer.transform = t
            var t = CGAffineTransformIdentity
//            t = CGAffineTransformTranslate(t, CGFloat(100), CGFloat(300))
//            t = CGAffineTransformRotate(t, CGFloat(M_PI_4))
            t = CGAffineTransformScale(t, CGFloat(0.3), CGFloat(0.3))
            self.tips.transform = t
            
            }, completion: nil)
    }
    func addTips(){
        tips = UITextField(frame: CGRect(x: 100, y: 300, width: 200, height: 50))
        tips.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        tips.text = "是吧"
        tips.layer.opacity = 1
        tips.textAlignment = .Center
        tips.textColor = UIColor.whiteColor()
        tips.layer.cornerRadius = 20
        tips.hidden = true
        self.view.addSubview(tips)
    }
    
    func setTipsTitle(title: String){
        tips.text = title
    }
    
}
