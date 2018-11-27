//
//  CategoryItemView.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/11/24.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit

class CategoryItemView: UIView {

    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var includeWordsCount: UILabel!
    
    let nextImage = UIImage(named: "noun_Arrow_18953")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCategoryItem()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setCategoryItem(){
        let imageview = UIImageView(image: nextImage)
        imageview.frame = CGRect(x:self.frame.width - 40, y:20,
                                 width:20, height:20)
        includeWordsCount.textColor = UIColor.AppColor.textColor
        self.addSubview(imageview)
    }
}
