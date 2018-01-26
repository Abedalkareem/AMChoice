//
//  AMRadioButton.swift
//  SDQ
//
//  Created by abedalkareem omreyh on 2/11/17.
//  Copyright © 2017 abedalkareem omreyh. All rights reserved.
//  GitHub: https://github.com/Abedalkareem/AMChoice
//
import UIKit
import ObjectiveC

@IBDesignable
class AMChoice: UIView,UITableViewDelegate,UITableViewDataSource {
    
    private let tableView = UITableView()
    
    private var lastIndexPath: IndexPath?

    /// The object that acts as the delegate of the AMChoice.
    /// The delegate must adopt the AMChoiceDelegate protocol.
    var delegate: AMChoiceDelegate? = nil
    //
    var separatorStyle: UITableViewCellSeparatorStyle = .singleLine
    var font: UIFont?
    
    /// The type of selection in the choices. `.single` is the default
    var selectionType: SelectionType = .single
    
    /// The choices that will show in the view, all item should adopt the Selectable protocol
    var data: [Selectable] = [] {
        didSet {
            // set selected item index if there is defult selected item
            if let index = data.index(where: { $0.isSelected } ) {
                lastIndexPath = IndexPath(item: index, section: 0)
            }
            tableView.reloadData() // when data set, reload tableview
        }
    }
    
    
    // cell customization variables
    /// The height of the cell the default is 50
    @IBInspectable var cellHeight: CGFloat = 50
    /// Selected status image
    @IBInspectable var selectedImage: UIImage?
    /// Unselected status image
    @IBInspectable var unselectedImage: UIImage?
    /// The arrow image, by default there is no arrow image
    @IBInspectable var arrowImage: UIImage?
    /// If your app language right to left you need to set it to true, the default is false
    @IBInspectable var isRightToLeft: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
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
    final func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
    }
    
    final func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = RadioCell()
        
        let item = data[indexPath.row]
        
        // set the image of radio depend of the status of the item (selected ,unselected)
        cell.imgRadio.image = item.isSelected ? selectedImage : unselectedImage
        
        cell.imgArrow.image = arrowImage
        
        cell.lblTitle.text = item.title
        cell.lblTitle.font = font ?? cell.lblTitle.font
        
        cell.isRightToLeft = isRightToLeft
        
        return cell
    }
    
    final func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return cellHeight
    }
    
    final func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
    
    /// Get all selected items.
    ///
    /// - returns: An array of selectable items that selected.
    func getSelectedItems() -> [Selectable] {
        
        let selectedItem = data.filter { (item) -> Bool in
            return item.isSelected == true
        }
        
        return selectedItem
    }
    
    /// Get all selected items as string.
    ///
    /// - parameter separator: A string to insert between
    ///   each of the elements in this sequence. The default separator is the comma.
    ///
    /// - returns: A string with selected items.
    func getSelectedItemsJoined(separator: String = ",") -> String {
        
        let selectedItem = data.filter { (item) -> Bool in
            return item.isSelected == true
            }.map{String($0.title)}.joined(separator: separator)
        
        return selectedItem
    }
    
    
}

/// The delegate of a AMChoice object must adopt the AMChoiceDelegate protocol.
/// Method of the protocol allow the delegate to get notfiy when choice selected.
@objc protocol AMChoiceDelegate: class {
    /// Called when choice selected
    ///
    /// - parameter indexPath: Contain the index of selected choice
    func didSelectRowAt(indexPath: IndexPath)
}

// all items should implement Selectable protocol
@objc protocol Selectable {
    var isSelected: Bool{ get set }
    var title: String{ get set }
    var isUserSelectEnable: Bool{ get set }
    
}

class Item: NSObject,Selectable {
    
    var title: String
    var isSelected: Bool = false
    var isUserSelectEnable: Bool = true // set it false if you want to make this item unselectable
    
    init(title: String, isSelected: Bool, isUserSelectEnable: Bool) {
        self.title = title
        self.isSelected = isSelected
        self.isUserSelectEnable = isUserSelectEnable
    }
    
}


extension Sequence where Iterator.Element == Selectable {
    func getSelectedItemsJoined(separator: String) -> String {
        
        let selectedItem = self.filter { (item) -> Bool in
            return item.isSelected == true
            }.map{String($0.title)}.joined(separator: separator)
        
        return selectedItem
    }
}

// Two type of selection single and multiple
@objc enum SelectionType: NSInteger{
    case single
    case multiple
}

//cell used to show selectable items
class RadioCell: UITableViewCell{
    var lblTitle: UILabel = UILabel()
    var imgRadio: UIImageView = UIImageView()
    var imgArrow: UIImageView = UIImageView()
    
    var isRightToLeft: Bool!
    
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

