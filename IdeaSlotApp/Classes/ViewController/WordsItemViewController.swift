//
//  WordsItemViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/07/29.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import RealmSwift

class WordsItemViewController: UIViewController {
    @IBOutlet weak var wordField: UITextField!

    var word:Words? = nil
    let realm = try! Realm()
    
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func save(_ sender: UIButton) {
        if word != nil{
            edit()
        }else{
            create()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let taskToDo = word{
            wordField.text = taskToDo.word
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func create() {
        let newTask = Words()
        newTask.word = wordField.text
        newTask.userId = "test-user"
        newTask.createDate = Date()
        try! realm.write(){
            realm.add(newTask)
        }
    }
    
    func edit() {
        if let word = word{
            try! realm.write(){
                word.word = wordField.text
                realm.add(word)
            }
        }
    }
}
