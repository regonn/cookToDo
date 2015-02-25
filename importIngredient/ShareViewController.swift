//
//  ShareViewController.swift
//  importIngredient
//
//  Created by 田上健太 on 2/25/15.
//  Copyright (c) 2015 SonicGarden. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {

        let shareDefaults = NSUserDefaults(suiteName: "group.jp.sonicgarden.cookToDo")
        shareDefaults?.setObject(self.contentText, forKey: "stringKey")
        shareDefaults?.synchronize()
        
        let inputItem = self.extensionContext!.inputItems.first as NSExtensionItem
        let itemProvider = inputItem.attachments![0] as NSItemProvider

        if (itemProvider.hasItemConformingToTypeIdentifier("public.url")) {
            itemProvider.loadItemForTypeIdentifier("public.url", options: nil, completionHandler: { (urlItem, error) in

                let url = urlItem as NSURL;
                // 取得したURLを表示
                NSLog("\(url.absoluteString)")

                self.extensionContext!.completeRequestReturningItems([url], completionHandler: nil)

            })
        }
    }

    override func configurationItems() -> [AnyObject]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return NSArray()
    }

}
