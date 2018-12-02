//
//  CategoryItemCell.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/12/02.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit

open class CategoryItemCell : UITableViewCell {
    
    class var identifier: String { return String(describing: type(of: self)) }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    open override func awakeFromNib() {
    }
    
    open func setup() {
    }
    
    open class func height() -> CGFloat {
        return 48
    }
    
    open func setData(_ data: Any?) {
        self.backgroundColor = UIColor.AppColor.leftmenuCellColor
        self.textLabel?.font = UIFont.italicSystemFont(ofSize: 18)
        self.textLabel?.textColor = UIColor.AppColor.textColor
        self.accessoryType = .disclosureIndicator
        if let menuText = data as? String {
            self.textLabel?.text = menuText
        }
    }
    
    override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.alpha = 0.4
        } else {
            self.alpha = 1.0
        }
    }
    
    // ignore the default handling
    override open func setSelected(_ selected: Bool, animated: Bool) {
    }
    
}

