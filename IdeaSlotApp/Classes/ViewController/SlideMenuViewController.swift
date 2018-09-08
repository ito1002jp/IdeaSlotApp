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
    
    override func awakeFromNib(){
        let mainVC = storyboard?.instantiateViewController(withIdentifier: "ParentWordsView")
        let leftVC = storyboard?.instantiateViewController(withIdentifier: "PagingMenuVC01")
        let navigationController = UINavigationController(rootViewController: mainVC!)
        
        mainViewController = navigationController
        leftViewController = leftVC
        super.awakeFromNib()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
