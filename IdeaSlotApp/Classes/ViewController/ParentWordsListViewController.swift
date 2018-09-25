//
//  ParentWordsListViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/08/15.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit

class ParentWordsListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPlusButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        setNavigationBarTitle(title: "Words")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func ToWordsItemViewController(){
        self.performSegue(withIdentifier: "toWordsItem", sender: nil)
    }
    
    func setPlusButton(){
        let plusButtonImage1 = UIImage(named: "icons8-plus-32")
        let plusButtonImage2 = UIImage(named: "icons8-plus-40")
        let plusButtonImage3 = UIImage(named: "icons8-plus-48")
        let plusButton = UIButton()
        
        plusButton.frame = CGRect(x:325, y:650, width:50, height:50)
        plusButton.setImage(plusButtonImage3, for: .normal)
        plusButton.imageView?.contentMode = .scaleAspectFit
        plusButton.contentHorizontalAlignment = .fill
        plusButton.contentVerticalAlignment = .fill
        self.view.addSubview(plusButton)
        plusButton.addTarget(self, action: #selector(ParentWordsListViewController.ToWordsItemViewController), for: .touchUpInside)
    }
}
