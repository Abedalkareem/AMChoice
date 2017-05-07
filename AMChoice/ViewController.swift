//
//  ViewController.swift
//  AMChoice
//
//  Created by abedalkareem omreyh on 5/7/17.
//  Copyright © 2017 abedalkareem. All rights reserved.
//

import UIKit

class ViewController: UIViewController,AMChoiceDelegate {
    
    
    @IBOutlet weak var amChoiceView: AMChoice!

    let myItems = [
        VoteModel(title: "Will smith", isSelected: false, isUserSelectEnable: true),
        VoteModel(title: "Al pacino", isSelected: false, isUserSelectEnable: true),
        VoteModel(title: "Abedalkareem", isSelected: false, isUserSelectEnable: true),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        amChoiceView.isRightToLeft = false // use it to support right to left language
        
        amChoiceView.delegate = self // the delegate used to get the selected item when pressed
        
        amChoiceView.data = myItems // fill your item , the item may come from server or static in your code like i have done
        
        amChoiceView.selectionType = .single // selection type , single or multiple
        
        amChoiceView.cellHeight = 50 // to set cell hight
        
        amChoiceView.arrowImage = nil // use ot if you want to add arrow to the cell
        
        // you can set the selected and unselected image programmatically
        amChoiceView.selectedImage = UIImage(named: "selectedItem")
        amChoiceView.unselectedImage = UIImage(named: "unSelectedItem")
        
        
        
        
       
    }
    
    // get the selected item when pressed
    func didSelectRowAt(indexPath: IndexPath) {
        print("item at index \(indexPath.row) selected")
    }

   
    @IBAction func submit(_ sender: Any) {
        let selectedItems = amChoiceView.getSelectedItems() as! [VoteModel] // use getSelectedItems to get all selected item
        print(selectedItems)
        
        let selectedItemCommaSeparated = amChoiceView.getSelectedItemsJoined(separator: ",") // use getSelectedItemsJoined to get all selected item joined with separator (if the selection type multiple)
        print("\n\n\nComma Separated: \n \(selectedItemCommaSeparated)")
    }


}

