//
//  TheaterTableViewController.swift
//  Project4
//
//  Created by Wisam Thalij on 11/4/15.
//  Copyright (c) 2015 Wisam. All rights reserved.
//

import UIKit

class TheaterTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var TheatersList = [Theaters]()
    var TheatersList1 = [String]()
    var testTheater = [Theater_Keys]()
    var TableData:Array< String > = Array < String >()
    var TableData2:Array< String > = Array < String >()
    
    @IBOutlet weak var resultsDel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        get_data_from_url("http://theater-1104.appspot.com/theaters")
        // Load the sample data.
        //loadSampleTheater()
        
//        var theater_name: String
//        // The HTTP POST Request
//        let myUrl = NSURL(string:"http://theater-1104.appspot.com/theaters");
//        let request = NSMutableURLRequest(URL:myUrl!);
//        request.HTTPMethod = "GET";
//        //        theater_name = "name=";
//        //        theater_name += NameTextField.text;
//        //        theater_name += "&chambers=";
//        //        theater_name += ChambersNumber.text;
//        //        println("Theater_name=\(theater_name)")
//        //        //let postString = "name=testpost9&chambers=6";
//        let postString = "";
//        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
//        
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
//            data, response, error in
//            
//            if error != nil {
//                println("error=\(error)")
//                return
//            }
//            
//            // print out response object
//            println("******* response = \(response)")
//            
//            
//            // print out response body
//            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println("************ response data = \(responseString)")
//            self.testTheater = []
//            var err: NSError?
//            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err) as? NSDictionary
//            
//            if let parseJSON = json {
//                
//                if let element: AnyObject = parseJSON["keys"] {
//                    //println(element[0])
//                    //print("someInts is of type [Int] with \(element.count) items.")
//                    var i: Int
//                    for (i=0; i < element.count ; i++){
//                        //println(element[i])
//                        if let elem = element[i] as? NSNumber {
//                            let aString = elem.stringValue
//                            self.testTheater += [Theater_Keys(Tkeys: aString)]
//                            //println(aString)
//                            println(self.testTheater[i].Tkeys)
//                         }
//                    }
//                    
//                }
//                
//                //var Theater_keys = [String]()
//                //Theater_keys = parseJSON["keys"] as! [(String)]
//                //print("someInts is of type [Int] with \(Theater_keys.count) items.")
//                //                for key in Thearter_keys
//                //                    println("key: \(Thearter_keys[0]!)")
//                //println("Theatername: \(Theatername!)")
//                //self.TestName.text = Theatername
//                
//                //                var NumChambers = parseJSON["chambers"] as? Int
//                //                if let newNum = NumChambers {
//                //                    println(newNum)
//                //                    self.TestInt.text = String(newNum)
//                //                }
//                
//            }
        
//        }
//        
//        task.resume()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
//    func loadSampleTheater() {
//        //let photo1 = UIImage(named: "images")!
//        let Key1 = Theaters(Tkeys: "Caprese Salad")!
//        
//        //let photo2 = UIImage(named: "images")!
//        let Key2 = Theaters(Tkeys: "new key")!
//        
//        //let photo3 = UIImage(named: "images")!
//        let Key3 = Theaters(Tkeys: "new key2")!
//        
//        TheatersList += [Key1, Key2, Key3]
//        
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return TableData2.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cell = tableView.dequeueReusableCellWithIdentifier("TheatersListTableViewCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = TableData2[indexPath.row]
        return cell
//        let cellIdentifier = "TheatersListTableViewCell"
//        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TheatersListTableViewCell
//        
//        
//        // Fetches the appropriate meal for the data source layout.
//        let meal = self.testTheater[indexPath.row]
//        
//        cell.Tkey.text = "SomeText"//meal.Tkeys
////        var TheaterCell : Theater_Keys
////        TheaterCell = testTheater[indexPath.row]
////        cell.Tkey.text = TheaterCell.Tkeys
//        return cell
    }
    func get_data_from_url(url:String)
    {
        let httpMethod = "GET"
        let timeout = 15
        let url = NSURL(string: url)
        let urlRequest = NSMutableURLRequest(URL: url!,
            cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 15.0)
        let queue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(
            urlRequest,
            queue: queue,
            completionHandler: {(response: NSURLResponse!,
                data: NSData!,
                error: NSError!) in
                if data.length > 0 && error == nil{
                    let json = NSString(data: data, encoding: NSASCIIStringEncoding)
                    self.extract_json(json!)
                }else if data.length == 0 && error == nil{
                    println("Nothing was downloaded")
                } else if error != nil{
                    println("Error happened = \(error)")
                }
            }
        )
    }
    func extract_json(data:NSString)
    {
        var new_url: String
        var parseError: NSError?
        let jsonData:NSData = data.dataUsingEncoding(NSASCIIStringEncoding)!
        let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &parseError)
        if (parseError == nil)
        {
            
            if let Theater_list = json as? NSDictionary
            {
                println(Theater_list)
                if let T_key = Theater_list["keys"] as? NSArray {
                    
                    for key in T_key {
                        println(key)
                        if let elem = key as? NSNumber {
                            let aString = elem.stringValue
                            new_url = "http://theater-1104.appspot.com/theaters/"
                            new_url += aString
                            get_data_from_url2(new_url)
                            TableData.append((aString))
                        }
                        
                    }
                }
            }
        }
        do_table_refresh();
    }
    func get_data_from_url2(url:String)
    {
        //print("URL is \(url)")
        //println("First call")
        let httpMethod = "GET"
        let timeout = 15
        let url = NSURL(string: url)
        let urlRequest = NSMutableURLRequest(URL: url!,
            cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 15.0)
        let queue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(
            urlRequest,
            queue: queue,
            completionHandler: {(response: NSURLResponse!,
                data: NSData!,
                error: NSError!) in
                if data.length > 0 && error == nil{
                    let json = NSString(data: data, encoding: NSASCIIStringEncoding)
                    self.extract_json2(json!)
                }else if data.length == 0 && error == nil{
                    println("Nothing was downloaded")
                } else if error != nil{
                    println("Error happened = \(error)")
                }
            }
        )
    }
    
    func extract_json2(data:NSString)
    {
        //print("data is \(data)")
        var parseError: NSError?
        let jsonData:NSData = data.dataUsingEncoding(NSASCIIStringEncoding)!
        let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &parseError)
        if (parseError == nil)
        {
            //println(json)
            if let Theater_arr = json as? NSDictionary
            {
                //println("Theater_arr is \(Theater_arr)")
                if let Theater_name = Theater_arr["name"] as? String
                {
                    println("Theater name is : \(Theater_name)")
                    
                    if let Theater_ID = Theater_arr["key"] as? NSNumber
                    {
                        println("Theater name is : \(Theater_ID)")
                        let ID = Theater_ID.stringValue
                        TableData2.append(Theater_name + "  ID[ " + ID + " ]")
                    }
                }
                println("Llist is \(TableData2)")
            }
            
        }
        do_table_refresh();
    }
    func do_table_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: Actions
    
    @IBAction func DeleteTheater(sender: AnyObject) {
    }
    

}
