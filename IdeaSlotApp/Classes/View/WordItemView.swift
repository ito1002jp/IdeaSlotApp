//
//  WordItemView.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/11/10.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import DropDown

protocol InputTextDelegate {
    func textFieldDidEndEditing(item: WordItemView, value: String) ->()
}

class WordItemView: UIView {
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var categorybutton: UIButton!
    var delegate:InputTextDelegate! = nil
    var categoryName: String? = ""
    var wordId: String? = ""
    var beforeWord: String? =  ""
    var beforecategoryName: String? = ""
    
    let dropdown = DropDown()
    
    @IBAction func showDropdown(_ sender: Any) {
        dropdown.show()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setWordItem()
        setDropDown(button: categorybutton, dropdown: dropdown)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setDropDown(button:UIButton, dropdown:DropDown){
        dropdown.anchorView = button
        dropdown.selectionAction = {(index, item) in
            button.setTitle(item, for: .normal)
            self.categoryName = item
            if self.categoryName != self.beforecategoryName {
                self.textFieldDidEndEditing(self.textfield)
            }
        }
    }
    
    func setWordItem(){
        textfield.placeholder = "+"
        textfield.delegate = self
        categorybutton.setTitle("No Category", for: .normal)
        categorybutton.backgroundColor = UIColor.AppColor.buttonColor
        categorybutton.tintColor = UIColor.AppColor.buttonTextColor
        categorybutton.layer.cornerRadius = 5.0
        categorybutton.layer.masksToBounds = true
    }
}

extension WordItemView: UITextFieldDelegate{
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        if !textField.text!.isEmpty{
            self.delegate.textFieldDidEndEditing(item: self, value: textField.text!)
        }
    }
}
