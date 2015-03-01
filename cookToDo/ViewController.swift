//
//  ViewController.swift
//  cookToDo
//
//  Created by 田上健太 on 2015/02/25.
//  Copyright (c) 2015年 SonicGarden. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var ingredient = Ingredient()
    var ingredientModel = IngredientModel()

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var urlTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender as? UIBarButtonItem != self.saveButton {
            self.ingredient.html = "nil"
            return
        }
        if countElements(self.urlTextField.text) > 0 {
            var urlString = urlTextField.text
            var url = NSURL(string: urlString)
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
                self.ingredient.html = cssHTML! + ingredientsHTML!
                println(self.ingredient.html)
            })
            task.resume()
        }else{
            self.ingredient.html = "nil"
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}

