//
//  AMRadioButton.swift
//  SDQ
//
//  Created by abedalkareem omreyh on 2/11/17.
//  Copyright © 2017 DevBatch. All rights reserved.
//

import UIKit
import ObjectiveC

@IBDesignable
class AMChoice: UIView,UITableViewDelegate,UITableViewDataSource {

    let tableView = UITableView()
    
    // delegate used to get selected item index
    var delegate:AMChoiceDelegate? = nil
    var lastIndexPath:IndexPath?

    // defult selection type is single selection
    var selectionType:SelectionType = .single
    var data:[Selectable] = [] {
        didSet{
            tableView.reloadData() // when data set reload tableview
        }
    }
    
    
    
    // cell customize variable
    @IBInspectable var cellHeight:CGFloat = 50
    @IBInspectable var selectedImage:UIImage?
    @IBInspectable var unselectedImage:UIImage?
    @IBInspectable var arrowImage:UIImage?
    @IBInspectable var isRightToLeft:Bool = false

    
    // MARK: init
    
    init<T:Selectable>(data:[T]) {
        super.init(frame: CGRect())
        self.data = data
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // draw the tableview
    override func draw(_ rect: CGRect) {
        tableView.delegate = self
        tableView.dataSource = self
        self.addSubview(tableView)
        tableView.frame = rect
        let backgroundView = UIView(); backgroundView.backgroundColor = UIColor.white
        tableView.backgroundView = backgroundView
        #if TARGET_INTERFACE_BUILDER
            self.data = [Item(title: "Item 1", isSelected: false, isUserSelectEnable: true),
                        Item(title: "Item 2", isSelected: true, isUserSelectEnable: true),
                        Item(title: "Item 3", isSelected: false, isUserSelectEnable: true)]
        #endif

    }
    
 
    // MARK: TableView Delegate and datasource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = RadioCell()
        
        let item = data[indexPath.row]

        // set the image of radio depend of the status of the item (selected ,unselected)
        cell.imgRadio.image = item.isSelected ? selectedImage : unselectedImage
        
        cell.imgArrow.image = arrowImage

        cell.lblTitle.text = item.title
        
        cell.isRightToLeft = isRightToLeft
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return cellHeight
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRowAt(indexPath: indexPath)
        
        // if item is unselectable .. return and don't select
        guard data[indexPath.row].isUserSelectEnable == true else{
            return
        }
        
        // if selection type single then select one item and remove selection from other
        if selectionType == .single {
            for i in 0..<data.count {
                data[i].isSelected = false
            }
            data[indexPath.row].isSelected = true
        }else{ // if selection type multible then select item pressed
            let item = data[indexPath.row]
            item.isSelected = !item.isSelected
        }
        
        if let lastIndexPath = lastIndexPath {
            tableView.reloadRows(at: [lastIndexPath], with: .automatic)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        lastIndexPath = indexPath

    }
    
    // MARK: Get selected item functions
    
    // get all selected items
    func getSelectedItems() -> [Selectable]{
        
        let selectedItem = data.filter { (item) -> Bool in
            return item.isSelected == true
        }
        
        return selectedItem
    }
    
    // get all selected item with with string format
    func getSelectedItemsJoined(separator:String) -> String{
        
        let selectedItem = data.filter { (item) -> Bool in
            return item.isSelected == true
            }.map{String($0.title)}.joined(separator: separator)
        
        return selectedItem
    }

    
}

// AMChoiceDelegate delegate used to inform the delegate that the item selected
@objc protocol AMChoiceDelegate: class {
    func didSelectRowAt(indexPath: IndexPath)
}

// all items should implement Selectable protocol
@objc protocol Selectable {
    var isSelected:Bool{ get set }
    var title:String{ get set }
    var isUserSelectEnable:Bool{ get set }
    
}

class Item: NSObject,Selectable {
    
    var title: String
    var isSelected: Bool = false
    var isUserSelectEnable: Bool = true // set it false if you want to make this item unselectable
    
    init(title:String,isSelected:Bool,isUserSelectEnable:Bool) {
        self.title = title
        self.isSelected = isSelected
        self.isUserSelectEnable = isUserSelectEnable
    }
    
}


 extension Sequence where Iterator.Element == Selectable {
    func getSelectedItemsJoined(separator:String) -> String{
        
        let selectedItem = self.filter { (item) -> Bool in
            return item.isSelected == true
            }.map{String($0.title)}.joined(separator: separator)
        
        return selectedItem
    }
}

// Two type of selection single and multiple
@objc enum SelectionType:NSInteger{
    case single
    case multiple
}

//cell used to show selectable items
class RadioCell:UITableViewCell{
    var lblTitle:UILabel = UILabel()
    var imgRadio:UIImageView = UIImageView()
    var imgArrow:UIImageView = UIImageView()
    
    var isRightToLeft:Bool!

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Configure cell views
        if isRightToLeft == true {
            imgRadio.frame = CGRect(x: rect.width - 30, y: 15, width: 20, height: 20)
            imgArrow.frame = CGRect(x: 20, y: 15, width: 20, height: 20)
            imgArrow.contentMode = .scaleAspectFit
            lblTitle.frame = CGRect(x: 0, y: 16, width: rect.width - 35, height: 20)
            lblTitle.textAlignment = .right
        }else{
            imgRadio.frame = CGRect(x: 10, y: 15, width: 20, height: 20)
            imgArrow.frame = CGRect(x: rect.width - 20, y: 15, width: 20, height: 20)
            imgArrow.contentMode = .scaleAspectFit
            lblTitle.frame = CGRect(x: 40, y: 16, width: rect.width - 10, height: 20)
            lblTitle.textAlignment = .left
        }
        
        // add cell views
        addSubview(imgRadio)
        addSubview(lblTitle)
        addSubview(imgArrow)

    }
   
}
