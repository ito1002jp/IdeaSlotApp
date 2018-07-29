//
//  TodoItemViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/07/29.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit

class ToDoItemViewController: UIViewController {

    @IBOutlet weak var ToDoField: UITextField!
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController!.popViewController(animated: true)
    }
    @IBAction func save(_ sender: UIBarButtonItem) {
        navigationController!.popViewController(animated: true)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
