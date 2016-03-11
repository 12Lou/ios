//
//  TimeViewController.swift
//  todo
//
//  Created by 子空 on 16/3/3.
//  Copyright © 2016年 子空. All rights reserved.
//

import UIKit

class TimeViewController: UIViewController {
    
    @IBOutlet weak var timePresent: UILabel!
    var timeRunning = false , time = 1 , Timer = NSTimer()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func startTap(sender: AnyObject) {
        if timeRunning {
            return
        }
        timeRunning = true
        Timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("UpdateTime"), userInfo: nil, repeats: true)
    }
    
    @IBAction func pauseTap(sender: AnyObject) {
        if timeRunning{
            Timer.invalidate()
            timeRunning = false
        }
    }
    
    func UpdateTime(){
        timePresent.text = String(time++)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.hidden = false
        UIApplication.sharedApplication().statusBarHidden = false
    } 
}
