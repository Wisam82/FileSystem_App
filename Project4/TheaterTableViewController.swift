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
        self.get_data_from_url("http://theater-1104.appspot.com/theaters")

    }

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
    }
    
    override func viewWillAppear(animated: Bool) {
       
        self.NewdataTable()
        
    }
    func NewdataTable () {
        TableData.removeAll()
        TableData2.removeAll()
        self.get_data_from_url("http://theater-1104.appspot.com/theaters")
        
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
        self.do_table_refresh();
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
        self.do_table_refresh();
    }
    func do_table_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            //self.get_data_from_url("http://theater-1104.appspot.com/theaters")
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
