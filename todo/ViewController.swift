//
//  ViewController.swift
//  todo
//
//  Created by 子空 on 16/2/28.
//  Copyright © 2016年 子空. All rights reserved.
//

import UIKit

var todos: [todoModel] = []

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        todos = [todoModel(uid: "1", title: "黄诚", sum: "亲历四年春疼紫荆野兽把领军，越明年" ),
                todoModel(uid: "2", title: "黄鹤楼记", sum: "亲历四年春疼紫荆野兽把领军，越明年" ),
                todoModel(uid: "3", title: "百日楼记", sum: "亲历四年春疼紫荆野兽把领军，越明年" )]
        navigationItem.leftBarButtonItem = editButtonItem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated )
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("reuseTableCell")! as UITableViewCell
        let todo = todos[indexPath.row] as todoModel
        
        let title = cell.viewWithTag(101) as! UILabel
        let sum = cell.viewWithTag(102) as! UILabel
        
        title.text = todo.title
        sum.text = todo.sum
        
        return cell
    }
    
    // 复写函数，实现删除功能
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            todos.removeAtIndex( indexPath.row )
            
            // 可配置动画效果
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic )
            // 数据重载，没有动画
            // self.tableView.reloadData()
            
        }
    }
    // 允许移动Move
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        return true
    }
    // 移动后，修改todos内元素的位置
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath){
        let todo = todos.removeAtIndex(sourceIndexPath.row)
        todos.insert(todo, atIndex: destinationIndexPath.row)
    }
    
    // 监听从另一个UIControllerView返回，这个时候可以在storybord上拖动到exit，会有提示
    @IBAction func close (segue: UIStoryboardSegue ){
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "cellToItem" {
            print("是从cell过来的")
            let ic = segue.destinationViewController as! ItemViewController
            
            let indexPath = tableView.indexPathForSelectedRow
            
            if let index = indexPath {
                 ic.todo = todos[index.row]
            }
            
           
        }
        
    }

}

