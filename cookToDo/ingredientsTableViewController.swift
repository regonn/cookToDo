//
//  ingredientsTableViewController.swift
//  cookToDo
//
//  Created by 田上健太 on 2015/02/25.
//  Copyright (c) 2015年 SonicGarden. All rights reserved.
//

import UIKit

class ingredientsTableViewController: UITableViewController, UIWebViewDelegate, UITableViewDataSource  {

    var ingredients = NSMutableArray()
    var ingredientModel = IngredientModel()
    var shareDefaults = NSUserDefaults(suiteName: "group.jp.sonicgarden.cookToDo")
    var push_objects = NSMutableArray()
    


    @IBOutlet weak var allClearButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 300

        self.ingredients = ingredientModel.all()
        allClearButton.addTarget(self, action: "deleteAll:", forControlEvents:.TouchUpInside)
        //self.tableView.estimatedRowHeight = 90
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.shareDefaults?.synchronize()
        if var objects: NSArray = shareDefaults?.objectForKey("urls") as? NSArray {
            for object in objects {
                println(object)
                self.addToModelFromUrl(object as NSString)
            }
        }
        self.shareDefaults?.setObject(self.push_objects, forKey: "urls")
        println("\(self.push_objects)")
        self.shareDefaults?.synchronize()
        self.push_objects = NSMutableArray()
    }

    func deleteAll(sender:UIButton!) {
        ingredientModel.deleteAll()
        self.ingredients = ingredientModel.all()
        self.tableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addToModelFromUrl(urlString: NSString){
        var url = NSURL(string: urlString)
        var request = NSURLRequest(URL: url!)

        var task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
            println("fetch start:\(url)")
            var html = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            var error :NSError?
            var htmlDocument = HTMLDocument(HTMLString: html, encoding: NSUTF8StringEncoding, error: &error)
            println(htmlDocument)
            if htmlDocument != nil {
                var body = htmlDocument?.body
                println(body)
                var title = htmlDocument?.title
                println(title)
                if body != nil && title != nil {
                    var titleHTML :String? = "<h4>" + title! + "<h4>"
                    println("title:\(title)")

                    var ingredientsXPathQuery :String? = "//div[@id='ingredients_list']"
                    var servingsXPathQuery :String? = "//span[@class='servings_for yield']"
                    var ingredients = body?.nodeForXPath(ingredientsXPathQuery!)

                    println("get ingredients")
                    var servings = body?.nodeForXPath(servingsXPathQuery!)
                    if servings != nil {
                        println("get servings")
                        var servingsHTML :String? = servings?.HTMLContent
                        titleHTML = titleHTML! + servingsHTML!
                    }
                    var ingredientsHTML :String? = ingredients?.HTMLContent
                    var cssHTML :String? = "<style type='text/css'>div.ingredient_name{display:inline;font-weight:500}div.amount{display:inline;}div.ingredient_category{color:red}body{background-color:#F7F3E8}</style>"

                    var ingredient = Ingredient()
                    ingredient.html = cssHTML! + titleHTML! + ingredientsHTML!
                    ingredient.title = title!
                    ingredient.id = self.ingredientModel.add(ingredient.html, title: ingredient.title)
                    self.ingredients.addObject(ingredient)
                    self.tableView.reloadData()
                }else{
                    println("failed access")
                    self.addPushObjects(urlString)
                }
            }
        })
        task.resume()
    }

    func addPushObjects(url: String){
        self.push_objects.addObject(url)
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
        self.ingredients = ingredientModel.all()
        return self.ingredients.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as CustomTableViewCell
        //var frame = cell.contentView.bounds
        //frame = CGRectInset(frame, 10, 10)
        //var webView = UIWebView(frame: frame)
        self.ingredients = ingredientModel.all()
        var webView = cell.webView

        var ingredient = self.ingredients.objectAtIndex(indexPath.row) as Ingredient
        var html = ingredient.html as String

        webView.loadHTMLString(html, baseURL: nil)
        webView.delegate = self
        //cell.contentView.addSubview(webView)
        cell.idLabel.text = String(ingredient.id)

        return cell
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
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        var source = segue.sourceViewController as ViewController
        var ingredient: Ingredient? = source.ingredient
        var html = ingredient?.html
        println(ingredient?.html)
        println(ingredient?.title)
        if html != "nil" {
            ingredient!.id = ingredientModel.add(ingredient!.html, title: ingredient!.title)
            self.ingredients.addObject(ingredient!)
            self.tableView.reloadData()
        }

    }

    // 空だけど editActionsForRowAtIndexPathの起動に必要
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var cell = tableView.cellForRowAtIndexPath(indexPath) as CustomTableViewCell
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler: {
            (action: UITableViewRowAction!, indexPath: NSIndexPath!) in
            println("Triggered delete action \(action) atIndexPath: \(indexPath)")
            self.ingredientModel.delete(cell.idLabel.text!)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            return
        })
        return [deleteAction]
    }

}
