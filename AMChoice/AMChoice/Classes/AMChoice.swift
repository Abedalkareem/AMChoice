//
//  AMRadioButton.swift
//  SDQ
//
//  Created by abedalkareem omreyh on 2/11/17.
//  Copyright © 2017 abedalkareem omreyh. All rights reserved.
//  GitHub: https://github.com/Abedalkareem/AMChoice
//
import UIKit

@IBDesignable
public class AMChoice: UIView, UITableViewDelegate, UITableViewDataSource {

  // MARK: - Properties

  /// The object that acts as the delegate of the AMChoice.
  /// The delegate must adopt the AMChoiceDelegate protocol.
  public var delegate: AMChoiceDelegate? = nil
  //
  public var separatorStyle: UITableViewCell.SeparatorStyle = .singleLine
  public var font: UIFont?

  /// The type of selection in the choices. `.single` is the default
  public var selectionType: SelectionType = .single

  /// The choices that will show in the view, all item should adopt the Selectable protocol
  public var data: [Selectable] = [] {
    didSet {
      // set selected item index if there is defult selected item
      if let index = data.firstIndex(where: { $0.isSelected } ) {
        lastIndexPath = IndexPath(item: index, section: 0)
      }
      tableView.reloadData() // when data set, reload tableview
    }
  }


  // cell customization variables
  /// The height of the cell the default is 50
  @IBInspectable public var cellHeight: CGFloat = 50
  /// Selected status image
  @IBInspectable public var selectedImage: UIImage?
  /// Unselected status image
  @IBInspectable public var unselectedImage: UIImage?
  /// The arrow image, by default there is no arrow image
  @IBInspectable public var arrowImage: UIImage?
  /// If your app language right to left you need to set it to true, the default is false
  @IBInspectable public var isRightToLeft: Bool = false

  // MARK: - Private properties

  private var tableView: UITableView!
  private var lastIndexPath: IndexPath?
  private var cellReuseIdentifier = "RadioCell"

  // MARK: - init

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }

  private func setup() {

    tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(RadioCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    #if TARGET_INTERFACE_BUILDER
    self.data = [Item(title: "Item 1", isSelected: false, isUserSelectEnable: true),
                 Item(title: "Item 2", isSelected: true, isUserSelectEnable: true),
                 Item(title: "Item 3", isSelected: false, isUserSelectEnable: true)]
    #endif
    addSubview(tableView)

    makeConstraints()
  }

  private func makeConstraints() {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: topAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
    tableView.separatorStyle = .none
  }

  // MARK: TableView Delegate and datasource

  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! RadioCell
    let item = data[indexPath.row]
    cell.setupWith(item,
                   arrowImage: arrowImage,
                   selectedImage: selectedImage,
                   unselectedImage: unselectedImage,
                   font: font)
    return cell
  }

  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

    return cellHeight
  }

  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

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
    } else { // if selection type multible then select item pressed
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
  public func getSelectedItems() -> [Selectable] {

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
  public func getSelectedItemsJoined(separator: String = ",") -> String {
    return data.filter { $0.isSelected}
      .map{String($0.title)}
      .joined(separator: separator)
  }

}

/// The delegate of a AMChoice object must adopt the AMChoiceDelegate protocol.
/// Method of the protocol allow the delegate to get notfiy when choice selected.
@objc public protocol AMChoiceDelegate: AnyObject {
  /// Called when choice selected
  ///
  /// - parameter indexPath: Contain the index of selected choice
  func didSelectRowAt(indexPath: IndexPath)
}

// all items should implement Selectable protocol
@objc public protocol Selectable {
  var isSelected: Bool{ get set }
  var title: String{ get set }
  var isUserSelectEnable: Bool{ get set }
}

public class Item: NSObject, Selectable {

  public var title: String
  public var isSelected: Bool = false
  public var isUserSelectEnable: Bool = true // set it false if you want to make this item unselectable

  init(title: String, isSelected: Bool, isUserSelectEnable: Bool) {
    self.title = title
    self.isSelected = isSelected
    self.isUserSelectEnable = isUserSelectEnable
  }

}

/// Two type of selection single and multiple
@objc public enum SelectionType: NSInteger {
  case single
  case multiple
}

/// Cell used to show selectable items
class RadioCell: UITableViewCell{

  // MARK: - Private properties

  private var titleLabel: UILabel!
  private var radioImageView: UIImageView!
  private var arrowImageView: UIImageView!

  // MARK: - init

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {

    selectionStyle = .none

    titleLabel = UILabel()
    titleLabel.numberOfLines = 0
    addSubview(titleLabel)

    radioImageView = UIImageView()
    addSubview(radioImageView)

    arrowImageView = UIImageView()
    arrowImageView.contentMode = .scaleAspectFit
    addSubview(arrowImageView)

    makeConstraints()
  }

  private func makeConstraints() {

    radioImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      radioImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
      radioImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      radioImageView.widthAnchor.constraint(equalToConstant: 20),
      radioImageView.heightAnchor.constraint(equalToConstant: 20)
    ])

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: radioImageView.trailingAnchor, constant: 10),
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
      titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
    ])

    arrowImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      arrowImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
      arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10),
      arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      arrowImageView.widthAnchor.constraint(equalToConstant: 20),
      arrowImageView.heightAnchor.constraint(equalToConstant: 20)
    ])
  }

  // MARK: - Setup

  func setupWith(_ selectable: Selectable,
                 arrowImage: UIImage?,
                 selectedImage: UIImage?,
                 unselectedImage: UIImage?,
                 font: UIFont?) {
    // set the image of radio depend of the status of the item (selected ,unselected)
    radioImageView.image = selectable.isSelected ? selectedImage : unselectedImage
    arrowImageView.image = arrowImage
    titleLabel.text = selectable.title
    titleLabel.font = font ?? titleLabel.font
  }

}

