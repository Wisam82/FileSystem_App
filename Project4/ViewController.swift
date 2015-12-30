//
//  ViewController.swift
//  Project4
//
//  Created by Wisam Thalij on 11/3/15.
//  Copyright (c) 2015 Wisam. All rights reserved.
//

import UIKit

var Tname : String = String()
var Tcham : String = String()
var TID: String = String()
var TID2: String = String()

class ViewController: UIViewController, UITextFieldDelegate {
    
    //Mark: Properties
    
    @IBOutlet weak var NameTextField: UITextField!

    @IBOutlet weak var ChambersNumber: UITextField!
    
    @IBOutlet weak var TestName: UILabel!
    
    @IBOutlet weak var TestInt: UILabel!
    
    @IBOutlet weak var NewKey: UILabel!
    
    @IBOutlet weak var Del_ID: UITextField!
    
    @IBOutlet weak var Results: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        TestName.text = textField.text
        Tname = TestName.text!
        Tcham = TestInt.text!
        TID = textField.text
    }
    // Send a POST request to add new Theater
    func Theater_Post(){
        // Handle the text field’s user input through delegate callbacks.
        NameTextField.delegate = self
        var theater_name: String
        // The HTTP POST Request
        let myUrl = NSURL(string:"http://theater-1104.appspot.com/theaters");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        theater_name = "name=";
        theater_name += NameTextField.text;
        theater_name += "&chambers=";
        theater_name += ChambersNumber.text;
        theater_name += "&movies[]=";
        theater_name += "5649391675244544"
        println("Theater_name=\(theater_name)")
        //let postString = "name=testpost9&chambers=6";
        let postString = theater_name;
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            // print out response object
            println("******* response = \(response)")
            
            
            // print out response body
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("************ response data = \(responseString)")
            
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err) as? NSDictionary
            
            if let parseJSON = json {
                
                var Theatername = parseJSON["name"] as? String
                println("Theatername: \(Theatername!)")
                self.TestName.text = Theatername
                
                var NumChambers = parseJSON["chambers"] as? Int
                if let newNum = NumChambers {
                    println(newNum)
                    self.TestInt.text = String(newNum)
                }
                var KeyNum = parseJSON["key"] as? NSNumber
                if let newkey = KeyNum {
                    println(newkey)
                    self.NewKey.text = newkey.stringValue
                }
                
            }
            
        }
        
        task.resume()
    }
    // Send a POST request to add new Theater
    func Theater_GET(){
        // Handle the text field’s user input through delegate callbacks.
        //NameTextField.delegate = self
        var theater_name: String
        // The HTTP POST Request
        let myUrl = NSURL(string:"http://theater-1104.appspot.com/theaters");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "GET";
        let postString = "";
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            // print out response object
            println("******* response = \(response)")
            
            
            // print out response body
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("************ response data = \(responseString)")
            
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err) as? NSDictionary
            
            if let parseJSON = json {
                
                if let element: AnyObject = parseJSON["keys"] {
                    println(element[0])
                    //print("someInts is of type [Int] with \(element.count) items.")
                    var i: Int
                    for (i=0; i < element.count ; i++){
                        println(element[i])
                    }
                }
                
            }
            
        }
        
        task.resume()
    }
    // Send a POST request to add new Theater
    func Theater_Del(){
        // Handle the text field’s user input through delegate callbacks.
        //NameTextField.delegate = self
        var theater_name: String
        // The HTTP POST Request
        let myUrl = NSURL(string:"http://theater-1104.appspot.com/theaters/" + TID);
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "DELETE";
        let postString = "";
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            // print out response object
            println("******* response = \(response)")
            
            
            // print out response body
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("************ response data = \(responseString)")
            
            if let Result = responseString as? String {
                println("The result is: \(Result)")
                //TID2 = Result
                self.Results.text = Result
            }
            
        }
        
        task.resume()
    }
    // Mark Action
    
    @IBAction func AddTheater(sender: AnyObject) {
        //TestName.text = "Default text"
        TestName.text = NameTextField.text
        TestInt.text = ChambersNumber.text
        Theater_Post()
    }
    
    @IBAction func GetTheater(sender: AnyObject) {
        Theater_GET()
    }
    
    @IBAction func NewGet(sender: AnyObject) {
        Theater_GET()
    }

    @IBAction func GetNewTheater(sender: AnyObject) {
        Theater_GET()
    }
    
    @IBAction func Delete_Theater_Fun(sender: AnyObject) {
        TID = Del_ID.text
        //Results.text = TID
        Theater_Del()
        //Results.text = TID2
        
    }
    
}

