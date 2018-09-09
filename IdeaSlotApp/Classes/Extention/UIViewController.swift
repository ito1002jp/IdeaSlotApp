//
//  UIViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/09/08.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func setNavigationBarItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
//        self.addRightBarButtonWithImage(UIImage(named: "ic_notifications_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
//        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
//        self.slideMenuController()?.addRightGestures()
    }
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
//        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
//        self.slideMenuController()?.removeRightGestures()
    }
    
    func setNavigationBarTitle(title: String){
        let navigationTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        navigationTitle.font = UIFont.systemFont(ofSize: 21)
        navigationTitle.text = title
        navigationTitle.textAlignment = .center
        self.navigationItem.titleView = navigationTitle
    }
}
