//
//  SlideMenuViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/09/08.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class SlideMenuViewController: SlideMenuController {
    
    override func viewDidLoad() {
        setUpSlideMenuOptions()
        super.viewDidLoad()
    }
    
    override func isTagetViewController() -> Bool {
        if let vc = UIApplication.topViewController() {
            if vc is ParentWordsListViewController ||
                vc is CategoryListViewController ||
                vc is ParentIdeaListViewController ||
                vc is MainViewController{
                return true
            }
        }
        return false
    }
    
    func setUpSlideMenuOptions(){
        SlideMenuOptions.leftBezelWidth = 300
    }
}
