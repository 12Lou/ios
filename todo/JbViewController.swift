//
//  JbViewController.swift
//  todo
//
//  Created by 子空 on 16/3/4.
//  Copyright © 2016年 子空. All rights reserved.
//

import UIKit

import AVKit
import AVFoundation


var data = [video(title:"朝闻道", image: "0", source: "shit",fileType:"mp4"),
    video(title:"夕死可矣", image: "0", source: "Full",fileType:"mp4"),
    video(title:"子在川上曰", image: "0", source: "Full",fileType:"mp4"),
    video(title:"逝者如斯夫", image: "0", source: "Full",fileType:"mp4"),
    video(title:"不舍昼夜", image: "0", source: "Full",fileType:"mp4")]

// 晚上遇到坑爹的问题，为UITableView添加class一直添加不上，吧UITableView替换为UIView之后，才能添加
// 这说明class继承的viewController要和 storyboard上的view是一一对应的
class JbViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var videoTable: UITableView!
    
    
    @IBOutlet weak var nav: UINavigationItem!
    var statusBarView: UIView = UIView()
    
    var playViewController = AVPlayerViewController()
    var playerView = AVPlayer()
    
    var refreshControl = UIRefreshControl()
    var refresh = false {
        didSet{
            if self.refresh {
                self.refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
                self.refreshControl.beginRefreshing()
            }else{
                self.refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新")
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoTable.dataSource = self
        videoTable.delegate = self
        
        nav.title = "视频列表"
        
        
        self.refreshControl.addTarget(self, action: "onPullToFresh", forControlEvents: UIControlEvents.ValueChanged)
//        self.refreshControl.backgroundColor = UIColor.redColor()
        self.refreshControl.tintColor = UIColor.yellowColor()
        self.videoTable.addSubview(refreshControl)
        
        // 移除一个Subview
        // statusBarView.removeFromSuperview()
        
//        let logo = UIImage(named: "nav.jpg")
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 320, height: 38))
//        imageView.contentMode = .ScaleAspectFit
//        imageView.image = logo
//        nav.titleView = imageView
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func addStatusBarBackground(RESET: Bool){
        // 如想隐藏状态栏，需在Info.plist中设置UIViewControllerBasedStatusBarAppearance 为NO
        //        UIApplication.sharedApplication().statusBarHidden = true
        
        if RESET{
            UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
            statusBarView.removeFromSuperview()
            return
        }
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        statusBarView = UIView(frame: CGRectMake(0.0, 0.0, 420.0, 20.0))
        
        // give it some color
        statusBarView.backgroundColor = UIColor.redColor()
        
        // and add it to your view controller's view
        view.addSubview(statusBarView)
    }
    
    func setNavStyle(RE: Bool){
        self.title = "嘿嘿"
        let navb = (navigationController?.navigationBar)!
        
        if !RE {
            navb.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default )
            navb.shadowImage = UIImage()
            navb.translucent = true
            
            // 左右按钮颜色编辑
            navb.tintColor = UIColor.whiteColor()
            // title样式
            navb.titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.whiteColor()
            ]
            // 设置导航栏颜色
            navb.backgroundColor = UIColor(red: 200, green: 0, blue: 0, alpha: 1)
            
        }else{
            navb.translucent = false
            navb.tintColor = UIColor.blueColor()
            navb.titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.darkTextColor()
            ]
            navb.backgroundColor = UIColor.whiteColor()
        }
    } 
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        // 通过另一个swift文件来定义不同cell
        let cell = videoTable.dequeueReusableCellWithIdentifier("videoCell", forIndexPath: indexPath) as! videoCell
        let video = data[indexPath.row]
        
//        cell.bgd. = UIImage(named: video.image) 
//        cell.bgd.setBackgroundImage(UIImage(named: video.image), forState: UIControlState.Normal ) 
//        cell.bgd.setTitle("", forState: UIControlState.Normal)
//        cell.bgd.adjustsImageWhenHighlighted = false
        
        cell.bgd.image = UIImage(named: video.image)
        cell.title.text = video.title
        cell.source.text = video.source
        cell.title.layer.zPosition = 1
        cell.source.layer.zPosition = 1
        
        cell.tag = indexPath.row
        
        
         
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //提示窗
       playViedeo(indexPath.row)
    }
    
    
    func playViedeo(row: Int ){
        // 需要注意的是，文件必须是右键 add file to，才能找到正确地址，不然会返回nil
        let filename: String = data[row].source
        let fileType: String = data[row].fileType
        
        let path = NSBundle.mainBundle().pathForResource( filename, ofType: fileType) 
        
        playerView = AVPlayer(URL: NSURL(fileURLWithPath: path!))
        
        playViewController.player = playerView
        
        self.presentViewController(playViewController, animated: true) {
            self.playViewController.player?.play()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        setNavStyle(false)
        addStatusBarBackground(false)
    }
    override func viewWillDisappear (animated: Bool) {
        setNavStyle( true)
        addStatusBarBackground(true)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }
    
    // 下拉刷新
    func pullRefresh(){
        
    }
    
    var timer: NSTimer!
    func onPullToFresh(){
        print("获取新数据")
        self.refresh = true
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("getData"), userInfo: nil, repeats: false)
        
    }
    func getData(){
        print("数据获取成功")
        self.refresh = false
        timer.invalidate()
        data.insert(video(title: "who r u", image: "0", source: "shit", fileType: "mp4"), atIndex: 0)
        // 希望的是，滚动结束后，再去刷新数据
//        UIView.animateWithDuration(0.2, animations: {
//            self.videoTable.reloadData()
//        })
        
        // 更新数据后有抖动
    }
    
    var dragging = false
    // 开始拖动
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        dragging = true
//        print("什么意思呢")
//        if !refreshControl.refreshing {
//            refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
//        }
    }
     
    // 拖动结束
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("松开手指，舒心数据")
        dragging = false
        if videoTable.contentOffset.y < -10 && !refresh {
            onPullToFresh()
        }
        
    }
    // 滚动中
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // videoTable.contentOffset.y相对视窗的位置
        let y = videoTable.contentOffset.y
        if dragging && y < -10 && !refresh {
            self.refreshControl.attributedTitle = NSAttributedString(string: "松开手指刷新")
        }
        
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        let y = videoTable.contentOffset.y
        if y == -64.0 {
            self.videoTable.reloadData()
        }
    }

    
}
