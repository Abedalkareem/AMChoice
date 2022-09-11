//
//  ViewController.swift
//  AMChoice
//
//  Created by abedalkareem omreyh on 5/7/17.
//  Copyright © 2017 abedalkareem. All rights reserved.
//

import UIKit
import AMChoice

class ViewController: UIViewController, AMChoiceDelegate {

  @IBOutlet private weak var amChoiceView: AMChoiceView!

  let myItems = [
    VoteModel(title: "Will smith", isSelected: false, isUserSelectEnable: true),
    VoteModel(title: "Al pacino", isSelected: true, isUserSelectEnable: true),
    VoteModel(title: "Abedalkareem", isSelected: false, isUserSelectEnable: true)
  ]

  override func viewDidLoad() {
    super.viewDidLoad()

    amChoiceView.isRightToLeft = false // use it to support right to left language.

    amChoiceView.delegate = self // the delegate used to get the selected item when pressed

    amChoiceView.data = myItems // fill your item , the item may come from server or static in your code like i have done

    amChoiceView.selectionType = .single // selection type , single or multiple

    amChoiceView.cellHeight = 50 // to set cell hight

    amChoiceView.arrowImage = nil // use ot if you want to add arrow to the cell

    // you can set the selected and unselected image programmatically
    amChoiceView.selectedImage = #imageLiteral(resourceName: "selectedItem")
    amChoiceView.unselectedImage = #imageLiteral(resourceName: "unSelectedItem")
  }

  // get the selected item when pressed
  func didSelectRowAt(indexPath: IndexPath) {
    print("item at index \(indexPath.row) selected")
  }

  @IBAction func submit(_ sender: Any) {
    let selectedItems = amChoiceView.getSelectedItems() as? [VoteModel] // use getSelectedItems to get all selected item
    print(selectedItems ?? [])

    // use getSelectedItemsJoined to get all selected item joined with separator (if the selection type multiple)
    let selectedItemCommaSeparated = amChoiceView.getSelectedItemsJoined(separator: ",")
    print("\n\n\nComma Separated: \n \(selectedItemCommaSeparated)")
  }
}
