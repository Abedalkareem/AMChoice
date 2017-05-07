//
//  VoteModel.swift
//  AMChoice
//
//  Created by abedalkareem omreyh on 5/7/17.
//  Copyright © 2017 abedalkareem. All rights reserved.
//

import UIKit

class VoteModel: NSObject,Selectable {
    var title: String
    var isSelected: Bool = false
    var isUserSelectEnable: Bool = true
    
    init(title:String,isSelected:Bool,isUserSelectEnable:Bool) {
        self.title = title
        self.isSelected = isSelected
        self.isUserSelectEnable = isUserSelectEnable
    }
}
