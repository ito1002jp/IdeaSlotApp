//
//  ViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/07/22.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import PageMenu

class ViewController: UIViewController {
    
    // インスタンス配列
    var controllerArray : [UIViewController] = []
    var pageMenu : CAPSPageMenu?
    
    // サイト情報
    let siteInfo:[Dictionary<String,String>] = [
        ["title":"ヤフー！知恵袋","url":"http://chiebukuro.yahoo.co.jp/"],
        ["title":"教えて！goo","url":"http://oshiete.goo.ne.jp/"],
        ["title":"OKWAVE","url":"http://okwave.jp/"],
        ["title":"発言小町","url":"http://komachi.yomiuri.co.jp/"],
        ["title":"BIGLOBEなんでも相談室","url":"http://soudan.biglobe.ne.jp/sp/"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for site in siteInfo {
            
            let controller:ContentsViewController = ContentsViewController(nibName: "ContentsViewController", bundle: nil)
            
            controller.title = site["title"]!
            controller.siteUrl = site["url"]!
            
            controller.webView = UIWebView(frame : self.view.bounds)
            controller.webView.delegate = controller
            controller.view.addSubview(controller.webView)
            let req = URLRequest(url: URL(string:controller.siteUrl!)!)
            controller.webView.loadRequest(req)
            controllerArray.append(controller)
            
        }
        
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            .bottomMenuHairlineColor(UIColor.blue),
            .selectionIndicatorColor(UIColor.red),
            .menuItemFont(UIFont(name: "HelveticaNeue", size: 14.0)!),
            .centerMenuItems(true),
            .menuItemWidthBasedOnTitleTextWidth(true),
            .menuMargin(16),
            .selectedMenuItemLabelColor(UIColor.black),
            .unselectedMenuItemLabelColor(UIColor.gray)
            
        ]
        
        // Initialize scroll menu
        
        let rect = CGRect(origin: CGPoint(x: 0,y :20), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: rect, pageMenuOptions: parameters)
        
        self.addChildViewController(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        
        pageMenu!.didMove(toParentViewController: self)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

