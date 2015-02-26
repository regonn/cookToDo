//
//  ingredientsTableViewController.swift
//  cookToDo
//
//  Created by 田上健太 on 2015/02/25.
//  Copyright (c) 2015年 SonicGarden. All rights reserved.
//

import UIKit

class ingredientsTableViewController: UITableViewController, UIWebViewDelegate  {

    var ingredients = NSMutableArray()
    var ingredientModel = IngredientModel()
    var sharedDefaults = NSUserDefaults(suiteName: "group.jp.sonicgarden.cookToDo")
    


    @IBOutlet weak var allClearButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()



        self.ingredients = ingredientModel.all()
        allClearButton.addTarget(self, action: "deleteAll:", forControlEvents:.TouchUpInside)
        //self.tableView.estimatedRowHeight = 90
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.sharedDefaults?.synchronize()
        var objects: NSArray = sharedDefaults?.objectForKey("urls") as NSArray
        for object in objects {
            if object as NSString != "https://www.yahoo.com/" {
                self.addToModelFromUrl(object as NSString)
            }
        }
        println(objects)
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

    func addToModelFromUrl(url: NSString){
        var url = NSURL(string: url)
        var request = NSURLRequest(URL: url!)

        var task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
            var html = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            var error :NSError?
            var htmlDocument = HTMLDocument(HTMLString: html, encoding: NSUTF8StringEncoding, error: &error)
            var body = htmlDocument?.rootNode
            var title = htmlDocument?.title
            var ingredientsXPathQuery :String? = "//div[@id='ingredients_list']"
            var ingredients = body?.nodeForXPath(ingredientsXPathQuery!)
            var ingredientsHTML :String? = ingredients?.HTMLContent
            var cssHTML :String? = "<style type='text/css'>div.ingredient_name{display:inline;}div.amount{display:inline;}div.ingredient_category{}</style>"
            var ingredient = Ingredient()
            ingredient.html = cssHTML! + ingredientsHTML!
            ingredient.title = title!
            ingredient.id = self.ingredientModel.add(ingredient.html, title: ingredient.title)
            self.ingredients.addObject(ingredient)
            self.tableView.reloadData()
        })
        task.resume()
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
        return self.ingredients.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        var frame = cell.contentView.bounds
        frame = CGRectInset(frame, 10, 10)
        var webView = UIWebView(frame: frame)

        var ingredient = self.ingredients.objectAtIndex(indexPath.row) as Ingredient
        var html = ingredient.html as String

        webView.loadHTMLString(html, baseURL: nil)
        webView.delegate = self
        cell.contentView.addSubview(webView)
        //cell.textLabel!.text = ingredient.title as String

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

}
