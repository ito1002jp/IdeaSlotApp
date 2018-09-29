//
//  IdeasItemViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/09/27.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import RealmSwift
import DropDown

class IdeasItemViewController: UIViewController {

    var pickerview01 = UIPickerView()
    var pickerview02 = UIPickerView()
    var pickerview03 = UIPickerView()
    var categoryButton01 = UIButton()
    var categoryButton02 = UIButton()
    var categoryButton03 = UIButton()
    var categoryId:Int = 0
    var pickerList01 = Array<String>()
    var pickerList02 = Array<String>()
    var pickerList03 = Array<String>()
    
//    var words = Array<String>()
    var operatorList = ["+","-","×","÷"]
    var operatorButton = UIButton()

    let realm = try!Realm()
    let categoryDropDown = DropDown()
    var wordList:Results<Words>? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        wordList = realm.objects(Words.self)
        pickerview01.frame = CGRect(x: 0, y: 200, width: self.view.frame.width, height: 100)
        pickerview02.frame = CGRect(x: 0, y: 400, width: self.view.frame.width, height: 100)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarTitle(title: "Input Idea")
        pickerList01 = arrayWordList(categoryId: categoryId)
        setPickerView(pickerview: pickerview01, tag: 1)
        pickerList02 = arrayWordList(categoryId: categoryId)
        setPickerView(pickerview: pickerview02, tag: 2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //setting DropDown(Category)
    func setupCategoryDropDown(categoryButton:UIButton){
        categoryDropDown.anchorView = categoryButton
        categoryDropDown.dataSource = arrayCategoryList()
        categoryDropDown.selectionAction = { [weak self] (index, item) in
            categoryButton.setTitle(item, for: .normal)
        }
    }
    
    func setPickerView(pickerview: UIPickerView, tag:Int){
        pickerview.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
//        pickerview.center = self.view.center
        pickerview.tag = tag
        pickerview.delegate = self
        pickerview.dataSource = self
        self.view.addSubview(pickerview)
    }
    
    func arrayWordList(categoryId: Int) -> Array<String> {
        var wordNameList:[String] = []
        if categoryId != 0 {
            wordList = wordList!.filter("categoryId == %@", categoryId)
        }
        
        for word in wordList!{
            wordNameList.append(word.word!)
        }
        return wordNameList
    }

}

extension IdeasItemViewController: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerView)
    }
    
}

extension IdeasItemViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return pickerList01.count
        case 2:
            return pickerList02.count
        case 3:
            return pickerList03.count
        default:
            break
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return pickerList01[row] as String
        case 2:
            return pickerList02[row] as String
        case 3:
            return pickerList03[row] as String
        default:
            break
        }
        return "no list"
    }
    
}
