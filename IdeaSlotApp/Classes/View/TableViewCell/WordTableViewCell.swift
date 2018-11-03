//
//  WordTableViewCell.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/07/29.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import DropDown

protocol InputTextTableCellDelegate {
    func textFieldDidEndEditing(cell: WordTableViewCell, value: String) -> ()
}

class WordTableViewCell: UITableViewCell{

    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var categorybutton: UIButton!
    var delegate: InputTextTableCellDelegate! = nil
    var categoryName: String? = ""
    var wordId: String? = ""
    var beforeWord: String? =  ""
    var beforecategoryName: String? = ""
    var wordListViewController: WordsListViewController?
    
    let dropdown = DropDown()
    
    @IBAction func showDropDown(_ sender: Any) {
        dropdown.show()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        textfield.placeholder = "+"
        textfield.delegate = self
//        textfield.textColor = UIColor.white
        
        categorybutton.setTitle("[select category]", for: .normal)
//        categorybutton.backgroundColor = UIColor.blue
        setDropDown(button: categorybutton, dropdown: dropdown)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
}

extension WordTableViewCell: UITextFieldDelegate{
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate.textFieldDidEndEditing(cell: self, value: textField.text!)
    }
    
}
