//
//  CategoryListViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/08/12.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import RealmSwift
import SlideMenuControllerSwift

class CategoryListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var categoriesEntities: Results<Category>? = nil

    let realm = try! Realm()
    
    override func viewDidLoad() {
        print("did load")
        super.viewDidLoad()
        self.setNavigationBarItem()
        setNavigationBarTitle(title: "Category")
        
        tableView.register(UINib(nibName: "CategoryItemCell", bundle: nil),forCellReuseIdentifier:"CategoryItem")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("will appear")
        super.viewWillAppear(animated)
        categoriesEntities = realm.objects(Category.self)
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        print("will disappear")
        super.viewWillDisappear(animated)
        dismiss(animated: animated, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
        switch segue.identifier {
        case "toWordList":
            print("identifier",segue.identifier)
            let wordListViewController = segue.destination as! WordsListViewController
            let _ = wordListViewController.view
            let category = categoriesEntities![tableView.indexPathForSelectedRow!.row]
            wordListViewController.category = category
        default:
            break
        }
    }
}

/**
 TableView Dalegate
 **/
extension CategoryListViewController: UITableViewDelegate{
    //did select cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped cell")
        performSegue(withIdentifier: "toWordList", sender: nil)
//        let toWordList = WordsListViewController()
//        toWordList.modalTransitionStyle = .crossDissolve
//        navigationController?.pushViewController(toWordList, animated: true)
    }
    
    //can swipe table cell
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //edit action when swipe cell
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction: UITableViewRowAction = UITableViewRowAction(style: .default, title: "edit") { (action, index) -> Void in
            self.editForCell()
        };
        editAction.backgroundColor = UIColor.gray
        return [editAction]
    }
    
    //@available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        print("trailingSwipeActionsConfigurationForRowAt")
        let editAction = UIContextualAction.init(style: UIContextualAction.Style.normal, title: "edit", handler: { (action, view, completion) in
            //TODO: Edit
            self.editForCell()
        })
        editAction.backgroundColor = UIColor.gray
        
        let config = UISwipeActionsConfiguration(actions: [editAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    func editForCell(){
        print("edit for cell")
    }
    
    
}

/**
 TableView DataSource
 **/
extension CategoryListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let categoryEntity = categoriesEntities{
            return categoryEntity.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categories:Category
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryItem",for: indexPath) as! CategoryTableViewCell
        categories = categoriesEntities![indexPath.row]
        
        cell.categoryTitle.text = categories.categoryName
        cell.categoryTitle.numberOfLines = 0
        cell.categoryTitle.sizeToFit()
        cell.includeWordsCount.text = String(categories.words.count)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
