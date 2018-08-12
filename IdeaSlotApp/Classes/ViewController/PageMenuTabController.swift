//
//  PageMenuTabController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/08/12.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import PagingMenuController

class PageMenuTabController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("PageMenuTabController")
        
        //PagingMenuController
        let options = PagingMenuOptions()
        let pagingMenuController = PagingMenuController(options: options)
        
        //adjust tab height
        pagingMenuController.view.frame.origin.y += 20
        pagingMenuController.view.frame.size.height -= 20
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMove(toParentViewController: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

private struct PagingMenuOptions: PagingMenuControllerCustomizable{
    let pv1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PagingMenuVC01") as! PageViewController01
    let pv2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PagingMenuVC02") as! PageViewController02
    let pv3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PagingMenuVC03") as! PageViewController03
    let pv4 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ToDoList") as! ToDoListViewController

    fileprivate var componentType: ComponentType{
        return .all(menuOptions: MenuOption(), pagingControllers: pageViewControllers)
    }
    
    fileprivate var pageViewControllers: [UIViewController]{
        print("pageViewControllers")
        return [pv1, pv2, pv3, pv4]
    }
    
    fileprivate struct MenuOption: MenuViewCustomizable{
        var displayMode: MenuDisplayMode{
            return .segmentedControl
            //return .infinite(widthMode: .flexible, scrollingMode: .scrollEnabled)
        }
        var height: CGFloat {
            return 40
        }
        var backgroundColor: UIColor {
            return UIColor.lightGray
        }
        var selectedBackgroundColor: UIColor {
            return UIColor.gray
        }
        var focusMode: MenuFocusMode {
            return .roundRect(radius: 4, horizontalPadding: 4, verticalPadding: 4, selectedColor: UIColor.black)
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2(), MenuItem3(), MenuItem4()]
        }
    }
    
    fileprivate struct MenuItem1: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "page blue", color: UIColor.blue, selectedColor: UIColor.white))
        }
    }
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "page green", color: UIColor.green, selectedColor: UIColor.white))
        }
    }
    fileprivate struct MenuItem3: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "page yellow", color: UIColor.yellow, selectedColor: UIColor.white))
        }
    }
    fileprivate struct MenuItem4: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "ToDoList", color: UIColor.white, selectedColor: UIColor.white))
        }
    }
}


