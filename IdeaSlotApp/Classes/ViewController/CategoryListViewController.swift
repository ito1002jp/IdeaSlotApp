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
    var categiryEntities: Results<Category>? = nil
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if categiryEntities != nil{
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        setNavigationBarTitle(title: "Category")
        createNavigationBarButtonItem()
        categiryEntities = realm.objects(Category.self)
        if categiryEntities != nil{
            tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // action new button
    @objc func ToCategoryItemViewController(){
        self.performSegue(withIdentifier: "toCategoryItem", sender: nil)
    }

    
    func createNavigationBarButtonItem(){        
        //new button
        let rightBarbuttonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(CategoryListViewController.ToCategoryItemViewController))
        self.navigationItem.rightBarButtonItem = rightBarbuttonItem
    }
}

extension CategoryListViewController: UITableViewDelegate{
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(categiryEntities?[indexPath.row].categoryName as! String)
    }

}

extension CategoryListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let categoryEntity = categiryEntities{
            return categoryEntity.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"CategoryItemCell")!
        if let categoryEntity = categiryEntities{
            cell.textLabel!.text = categoryEntity[indexPath.row].categoryName
        }
        return cell
    }
}
