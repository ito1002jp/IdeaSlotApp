//
//  CategoryListViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/08/12.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import SwiftEntryKit
//import QuickLayout

class CategoryListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var categoryEntities: Results<Category>? = nil

    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        setNavigationBarTitle(title: "Category")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = .zero
        tableView.register(UINib(nibName: "CategoryItemCell", bundle: nil),forCellReuseIdentifier:"CategoryItem")
        tableView.tableFooterView = UIView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categoryEntities = realm.objects(Category.self)
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismiss(animated: animated, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toWordList":
            let wordListViewController = segue.destination as! WordsListViewController
            let category = categoryEntities![tableView.indexPathForSelectedRow!.row]
            wordListViewController.category = category
        default:
            break
        }
    }
    
    //set up regist form()
    func setFromView(){
        var attributes = EKAttributes.float
        attributes.position = .center
        attributes.name = "Category Form"
        attributes.windowLevel = .normal
        attributes.displayDuration = .infinity
        
        //From Color
        attributes.entryBackground = .color(color: .white)
        attributes.screenBackground = .color(color: UIColor(white: 0.5, alpha: 0.5))
        
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
        attributes.statusBar = .dark
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        
        //Form Entry
        let titleText = "Regist Category"
        let titleFont = UIFont.systemFont(ofSize: 25)

        let title = EKProperty.LabelContent(text: titleText, style: .init(font: titleFont, color: UIColor.AppColor.textColor))
        let style = EKProperty.LabelStyle(font: UIFont.systemFont(ofSize: 20.0), color: UIColor.AppColor.textColor)
        let textStyle = EKProperty.LabelStyle(font: UIFont.systemFont(ofSize: 20.0), color: UIColor.AppColor.textColor)
        let buttonTextStyle = EKProperty.LabelStyle(font: UIFont.systemFont(ofSize: 11.0), color: UIColor.AppColor.buttonTextColor)
        let buttonLabel = EKProperty.LabelContent(text: "Continue", style: buttonTextStyle)
        
        let textField = EKProperty.TextFieldContent.init(placeholder: EKProperty.LabelContent(text: "Category", style:style), textStyle: textStyle)
        let button = EKProperty.ButtonContent(label: buttonLabel, backgroundColor: UIColor.darkGray, highlightedBackgroundColor: UIColor.darkGray.withAlphaComponent(0.8)){
            SwiftEntryKit.dismiss()
        }
        
        let contentView = EKFormMessageView(with: title, textFieldsContent: [textField], buttonContent: button)
        attributes.lifecycleEvents.didAppear = {
            contentView.becomeFirstResponder(with: 0)
        }
        let action = {
            print("form text",textField)
            print("content view",contentView)
//            self.registCategory(categoryName: textField.textContent.description)
        }
        
        attributes.entryInteraction.customTapActions.append(action)
        
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    //regist category
    func registCategory(categoryName:String){
        print("put form button :",categoryName)
    }
}

/**
 TableView Dalegate
 **/
extension CategoryListViewController: UITableViewDelegate{
    //did select cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toWordList", sender: nil)
    }
}

/**
 TableView DataSource
 **/
extension CategoryListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let categoryEntity = categoryEntities{
            return categoryEntity.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categories:Category
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryItem",for: indexPath) as! CategoryTableViewCell
        cell.delegate = self
        categories = categoryEntities![indexPath.row]
        
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

/**
 SwipeCellKit TableViewCellDalegate
 **/
extension CategoryListViewController:SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let editAction = SwipeAction(style: .default, title: "Edit") { action, indexPath in
            print("swipe cell")
            self.setFromView()
        }
        editAction.transitionDelegate = ScaleTransition.default
        editAction.image = UIImage(named: "Edit")
        editAction.backgroundColor = UIColor.AppColor.editBackGroundColor
        
        return [editAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.transitionStyle = .reveal
        return options
    }
}
