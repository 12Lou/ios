//
//  ItemViewController.swift
//  todo
//
//  Created by 子空 on 16/2/28.
//  Copyright © 2016年 子空. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ItemViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var todoTitle: UITextField!
    @IBOutlet weak var todoSum: UITextField!
    
    var todo: todoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoTitle.delegate = self
        todoSum.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
        if let td = todo {
            todoTitle.text = td.title
            todoSum.text = td.sum
            
            navigationController?.title = "修改"
        }else{
            navigationController?.title = "新增"
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // enter闭合键盘
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // 失去焦点时，关闭键盘
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        todoTitle.resignFirstResponder()
        todoSum.resignFirstResponder()
    }
    
    @IBAction func okTap(sender: AnyObject) {
        if todo == nil{
            let uuid = NSUUID.init().UUIDString
            print(uuid)
            todos.append(todoModel(uid: uuid, title: todoTitle.text!, sum: todoSum.text!))
            
        }else{
            todo?.title = todoTitle.text!
            todo?.sum = todoSum.text!
        }
    }
    
    // swift http request
    @IBAction func httpReq(sender: AnyObject) {
        
        Alamofire.request(.GET, "http://localhost:3000/api", parameters: ["foo": "bar"])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                switch response.result {
                    case .Success :
                        if let json = response.result.value {
                            print("JSON: \(json)")
                            print( JSON(json)["cunt"] )
                        }
                    case .Failure(let error ) :
                            print(error )
                }
               
        }
//        do {
//            let opt = try HTTP.GET("http://localhost:3000/api")
//            opt.progress = { progress in
//                print("progress: \(progress)") //this will be between 0 and 1.
//            }
//            opt.start { response in
//                if let err = response.error {
//                    print("error: \(err.localizedDescription)")
//                    return //also notify app of failure as needed
//                }
//                
//                let resp = Response(JSONDecoder(response.data))
//                
//                if let status = resp.status {
//                    print("completed: \(status)")
//                }
//                
//                // 返回包括请求状态在内 status header url payload在内的数据
////                print("opt finished: \(response.description)")
//                
//                // print("data is: \(response.data)")  // 二进制 access the response of the data with response.data")
//            }
//        } catch let error {
//            print("got an error creating the request: \(error)")
//        }
    }
    @IBAction func nima (segue: UIStoryboardSegue ){
        
    }
    
}
