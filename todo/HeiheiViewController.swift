//
//  HeiheiViewController.swift
//  todo
//
//  Created by 子空 on 16/3/1.
//  Copyright © 2016年 子空. All rights reserved.
//

import UIKit

class HeiheiViewController: UIViewController , UIScrollViewDelegate {
    
    
    @IBOutlet weak var scrollViewHei: UIScrollView! 
    @IBOutlet weak var myImage: UIImageView!
    
    var button:UIButton!
    let hah = "caomima"
    func alertDeafault(){
        print("不知道说些什么")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollViewHei.delegate = self
        scrollViewHei.contentSize = (myImage.image?.size)!
        
        // 使用代码添加一个按钮
        button = UIButton(type: UIButtonType.System)
        button.frame = CGRect(x: 100, y: 100, width: 150, height: 40)
        button.backgroundColor = UIColor.whiteColor()
        button.setTitle("跳转到下一个页面", forState: UIControlState.Normal)
        button.addTarget(self, action: Selector("presetnVC"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        
        // 弹框
        let alert = UIAlertController(title: "Alert弹框", message: "我是message消息，哈哈哈哈，你大爷", preferredStyle: UIAlertControllerStyle.Alert)
        // 取消按钮
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: {(alert: UIAlertAction!) in print("取消按钮") } ))
        // 确认按钮
        // 要注意handler所对应的参数，{(alert: UIAlertAction) in code/func() }
        alert.addAction(UIAlertAction(title: "确认", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in self.alertDeafault() } ))
        // 直接弹出来
        self.presentViewController(alert, animated: true, completion: nil)
         
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView){
        print("开始",scrollViewHei.contentOffset.x)
        
    }
    func presetnVC(){
        print("什么鬼啊")
        clock()
    }
    
    var Timer = NSTimer() , num = 0
    var TIME_RUNNING = false
    //   计时器
    func clock(){
        TIME_RUNNING = !TIME_RUNNING
        if TIME_RUNNING {
            //  类似于setInterval
            Timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("UpdateTimer"), userInfo: nil, repeats: true)
        }else{
            // 类似于clearInterval
            Timer.invalidate()
        }
    }
    func UpdateTimer(){
//        print(num)
        num += 1
        button.setTitle("\(String(num) )什么意思呢", forState: UIControlState.Normal)
    }
    
}