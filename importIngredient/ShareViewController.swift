//
//  ShareViewController.swift
//  importIngredient
//
//  Created by 田上健太 on 2/25/15.
//  Copyright (c) 2015 SonicGarden. All rights reserved.
//

import UIKit
import Social

class ShareViewController: UIViewController {

    let shareDefaults = NSUserDefaults(suiteName: "group.jp.sonicgarden.cookToDo")

    override func viewDidLoad() {
        super.viewDidLoad()
        let inputItem = self.extensionContext!.inputItems.first as NSExtensionItem
        let itemProvider = inputItem.attachments![0] as NSItemProvider

        if (itemProvider.hasItemConformingToTypeIdentifier("public.url")) {
            itemProvider.loadItemForTypeIdentifier("public.url", options: nil, completionHandler: { (urlItem, error) in

                let url = urlItem as NSURL;
                var urlString = url.absoluteString

                var objects = NSMutableArray()

                var fetch_objects: NSArray? = self.shareDefaults?.objectForKey("urls") as? NSArray
                println(fetch_objects)
                if fetch_objects == nil {
                    fetch_objects = NSMutableArray()
                }
                for item in fetch_objects! {
                    objects.addObject(item)
                }

                if urlString!.rangeOfString("cookpad.com/recipe/") != nil {
                    objects.addObject(urlString!)
                    self.shareDefaults?.setObject(objects, forKey: "urls")
                    self.shareDefaults?.synchronize()
                    self.showRegisteredAlert()
                } else {
                    self.invalidUrlAlert()
                }

            })
        }
    }

    func showRegisteredAlert(){
        let alert = UIAlertController(title: "", message: "登録できました", preferredStyle: UIAlertControllerStyle.Alert)

        let defaultAction = UIAlertAction(title: "OK",
            style: .Default,
            handler:{
            (action:UIAlertAction!) -> Void in
                self.extensionContext!.completeRequestReturningItems(nil, completionHandler: nil)
        })

        alert.addAction(defaultAction)

        self.presentViewController(alert, animated: true, completion: nil)
    }

    func invalidUrlAlert(){
        let alert = UIAlertController(title: "", message: "現在cookpadのレシピのみに対応しています。", preferredStyle: UIAlertControllerStyle.Alert)

        let defaultAction = UIAlertAction(title: "OK",
            style: .Default,
            handler:{
                (action:UIAlertAction!) -> Void in
                self.extensionContext!.completeRequestReturningItems(nil, completionHandler: nil)
        })

        alert.addAction(defaultAction)

        self.presentViewController(alert, animated: true, completion: nil)
    }

}
