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
public class AMChoiceView: UIView {

  // MARK: - Properties

  /// The object that acts as the delegate of the AMChoice.
  /// The delegate must implement the AMChoiceDelegate protocol.
  public weak var delegate: AMChoiceDelegate?

  /// TableViewCell separator style.
  public var separatorStyle: UITableViewCell.SeparatorStyle = .singleLine

  /// TableViewCell text font.
  public var font: UIFont?

  /// The type of selection in the choices. `.single` is the default.
  public var selectionType: SelectionType = .single

  /// The choices that will be shown in the view, all items should implement the Selectable protocol.
  public var data: [Selectable] = [] {
    didSet {
      // set selected item index if there is defult selected item
      if let index = data.firstIndex(where: { $0.isSelected }) {
        lastIndexPath = IndexPath(item: index, section: 0)
      }
      tableView.reloadData() // when data set, reload tableview
    }
  }

  /// The height of the cell, the default is `50`.
  @IBInspectable public var cellHeight: CGFloat = 50
  /// Selected status image.
  @IBInspectable public var selectedImage: UIImage?
  /// Unselected status image.
  @IBInspectable public var unselectedImage: UIImage?
  /// The arrow image, by default there is no arrow image.
  @IBInspectable public var arrowImage: UIImage?
  /// If your app language right to left you need to set it to true, the default is false which means `LTR`.
  @IBInspectable public var isRightToLeft: Bool = false

  // MARK: - Private Properties

  private var tableView: UITableView!
  private var lastIndexPath: IndexPath?
  private var cellReuseIdentifier = "RadioTableViewCell"

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
    tableView.register(RadioTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    #if TARGET_INTERFACE_BUILDER
    self.data = [DummyInterfaceBuilderItem(title: "Item 1", isSelected: false, isUserSelectEnable: true),
                 DummyInterfaceBuilderItem(title: "Item 2", isSelected: true, isUserSelectEnable: true),
                 DummyInterfaceBuilderItem(title: "Item 3", isSelected: false, isUserSelectEnable: true)]
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

  // MARK: - Public methods

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
    return data.filter { $0.isSelected }
      .map { String($0.title) }
      .joined(separator: separator)
  }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension AMChoiceView: UITableViewDelegate, UITableViewDataSource {

  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView
      .dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? RadioTableViewCell else {
      assertionFailure("Failed to get the tableview cell")
      return UITableViewCell()
    }
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

    // if item is unselectable.. return and don't select.
    guard data[indexPath.row].isUserSelectEnable == true else {
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
}

/// The delegate of a AMChoice object must adopt the AMChoiceDelegate protocol.
/// The method of the protocol allow the delegate to get notfiy when a choice selected.
@objc public protocol AMChoiceDelegate: AnyObject {
  /// Called when a choice selected.
  ///
  /// - parameter indexPath: Contain the index of selected choice.
  func didSelectRowAt(indexPath: IndexPath)
}

/// A protocol that should be implimented by any class that need to be used in the `AMChoiceView`.
@objc public protocol Selectable {
  /// Is the item selected.
  var isSelected: Bool { get set }
  /// The title that will be shown in the row.
  var title: String { get set }
  /// If false, the user can't select this choice.
  var isUserSelectEnable: Bool { get set }
}

/// A dummy items used to show the a dummy rows in the interface builder (Storyboard).
class DummyInterfaceBuilderItem: NSObject, Selectable {

  public var title: String
  public var isSelected: Bool = false
  public var isUserSelectEnable: Bool = true // set it false if you want to make this item unselectable

  init(title: String, isSelected: Bool, isUserSelectEnable: Bool) {
    self.title = title
    self.isSelected = isSelected
    self.isUserSelectEnable = isUserSelectEnable
  }

}

/// There are two types of selection, single and multiple.
/// Single means that the user can select one object, while multiple means
/// the user can select multiple items.
@objc
public enum SelectionType: NSInteger {
  case single
  case multiple
}
