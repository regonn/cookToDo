//
//  ShareViewController.swift
//  importIngredient
//
//  Created by 田上健太 on 2/25/15.
//  Copyright (c) 2015 SonicGarden. All rights reserved.
//

import UIKit
import Social

class ShareViewController:SLComposeServiceViewController {

    let shareDefaults = NSUserDefaults(suiteName: "group.jp.sonicgarden.cookToDo")
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {

        
        
        
        let inputItem = self.extensionContext!.inputItems.first as NSExtensionItem
        let itemProvider = inputItem.attachments![0] as NSItemProvider

        if (itemProvider.hasItemConformingToTypeIdentifier("public.url")) {
            itemProvider.loadItemForTypeIdentifier("public.url", options: nil, completionHandler: { (urlItem, error) in

                let url = urlItem as NSURL;
                var urlString = url.absoluteString
                // 取得したURLを表示
                NSLog("\(url.absoluteString)")
                var objects = NSMutableArray()
                objects.addObject(urlString!)
                self.shareDefaults?.setObject(objects, forKey: "urls")
                self.shareDefaults?.synchronize()
                println(objects)
                var fetch_objects: NSMutableArray? = self.shareDefaults?.objectForKey("urls") as? NSMutableArray
                println(fetch_objects)
            self.extensionContext!.completeRequestReturningItems([url], completionHandler: nil)

            })
        }
    }

    override func configurationItems() -> [AnyObject]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return NSArray()
    }

}
