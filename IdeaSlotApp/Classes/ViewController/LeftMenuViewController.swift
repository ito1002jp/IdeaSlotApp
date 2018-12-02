//
//  LeftMenuViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/08/12.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import RealmSwift

enum LeftMenu :Int{
    case words = 0
    case ideas
    case slot
    case categories
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftMenuViewController: UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    var menus = ["Words", "Ideas", "Idea Slot"]
    var wordsListViewController: UIViewController!
    var categoryListViewController: UIViewController!
    var ideasListViewController: UIViewController!
    var ideasSlotViewController: UIViewController!
    var mainViewController: UIViewController!
    var categoriesList:Results<Category>? = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.AppColor.backgroundLeftmenu
        self.tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: BaseTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorColor = UIColor.AppColor.separatorColor
        self.tableView.separatorInset = .zero
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let wordsListViewController = storyboard.instantiateViewController(withIdentifier: "WordsList")as! WordsListViewController
        let categoryListViewController = storyboard.instantiateViewController(withIdentifier: "CategoryList")as! CategoryListViewController
        let ideasListViewController = storyboard.instantiateViewController(withIdentifier: "IdeasList")as! IdeasListViewController
        let ideasSlotViewController = storyboard.instantiateViewController(withIdentifier: "IdeasSlot")as! IdeasSlotViewController
        self.wordsListViewController = UINavigationController(rootViewController: wordsListViewController)
        self.categoryListViewController = UINavigationController(rootViewController: categoryListViewController)
        self.ideasListViewController = UINavigationController(rootViewController: ideasListViewController)
        self.ideasSlotViewController = UINavigationController(rootViewController: ideasSlotViewController)
        
        let realm = try! Realm()
        categoriesList = realm.objects(Category.self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .words:
            self.slideMenuController()?.changeMainViewController(wordsListViewController, close: true)
        case .categories:
            self.slideMenuController()?.changeMainViewController(categoryListViewController, close: true)
        case .ideas:
            self.slideMenuController()?.changeMainViewController(ideasListViewController, close: true)
        case .slot:
            self.slideMenuController()?.changeMainViewController(ideasSlotViewController, close: true)
        }
    }
}

/**
 TableView Delegate
 **/
extension LeftMenuViewController: UITableViewDelegate{
    //height for row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row){
            switch menu{
            case .words, .categories, .ideas, .slot:
                return BaseTableViewCell.height()
            }
        }
        return 0
    }
    
    //height for header section
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        switch section {
        case 1:
            return BaseTableViewCell.height()
        default:
            break
        }
        return 0
    }

    //tableviewcell selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if let menu = LeftMenu(rawValue: indexPath.row){
                self.changeViewController(menu)
            }
        case 1:
            print("section :",indexPath.section)
            print("index :",indexPath.row)
            break
        default:
            break
        }
    }
    
    //section size
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        switch section {
//        case 0:
//            break
//        case 1:
//            let headerview = UIView()
//            let item = BaseTableViewCell()
//            item.setData("Categories")
//            headerview.addSubview(item)
//
//            return headerview
//        default:
//            break
//        }
//        return nil
//    }
    
    // Sectioのタイトル
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Categories"
        default:
            break
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return menus.count
        case 1:
            return categoriesList!.count
        default:
            break
        }
        return 0
    }
    
}

/**
 TableView DataSource
 **/
extension LeftMenuViewController : UITableViewDataSource {
    
    //tableview details
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let menu = LeftMenu(rawValue: indexPath.row)
        
        switch indexPath.section {
        case 0:
            switch menu {
            case .words?, .categories?, .ideas?, .slot?:
                let cell = BaseTableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(menus[indexPath.row])
                return cell
            default: break
            }
        case 1:
            let cell = BaseTableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
            cell.setData(categoriesList![indexPath.row].categoryName)
//            cell.textLabel?.frame = CGRect(x:20, y:0, width: cell.textLabel!.frame.size.width, height: cell.textLabel!.frame.size.height)
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
}
