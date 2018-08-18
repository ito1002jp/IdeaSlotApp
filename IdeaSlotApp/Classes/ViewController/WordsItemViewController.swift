//
//  TodoItemViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/07/29.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import RealmSwift

class WordsItemViewController: UIViewController {
    @IBOutlet weak var todoField: UITextField!

    var task:ToDo? = nil
    let realm = try! Realm()
    
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func save(_ sender: UIButton) {
        if task != nil{
            editTask()
        }else{
            createTask()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let taskToDo = task{
            todoField.text = taskToDo.item
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createTask() {
        let newTask = ToDo()
        newTask.item = todoField.text
        try! realm.write(){
            realm.add(newTask)
        }
    }
    
    func editTask() {
        if let task = task{
            try! realm.write(){
                task.item = todoField.text
                realm.add(task)
            }
        }
    }
}
