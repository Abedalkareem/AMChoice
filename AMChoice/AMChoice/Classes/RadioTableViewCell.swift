//
//  RadioTableViewCell.swift
//  AMChoice
//
//  Created by abedalkareem omreyh on 11/09/2022.
//

import UIKit

/// Cell used to show selectable items.
class RadioTableViewCell: UITableViewCell {

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
