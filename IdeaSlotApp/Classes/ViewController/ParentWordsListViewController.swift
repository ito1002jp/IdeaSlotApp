//
//  ParentWordsListViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/08/15.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit

class ParentWordsListViewController: UIViewController {

    @IBAction func pressButtn(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        setNavigationBarTitle(title: "Words")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
