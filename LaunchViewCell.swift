//
//  LaunchViewCell.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 31.07.2023.
//

import UIKit
import SDWebImage

class LaunchViewCell: UITableViewCell {
  static let sellIdentifier = "launchCell"
  // MARK: - Variables
  private var launch: Launch!
  private let patchImageView: UIImageView = {
    let launchImageView = UIImageView()
    launchImageView.contentMode = .scaleAspectFit
    launchImageView.image = UIImage(systemName: "questionmark")
    launchImageView.tintColor = .red
    return launchImageView
  }()
  private var launchName: UILabel = {
    let launchLabel = UILabel()
    launchLabel.textColor = .label
    launchLabel.textAlignment = .left
    launchLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    // launchLabel.adjustsFontSizeToFitWidth = true
    // launchLabel.lineBreakMode = .byCharWrapping
    launchLabel.text = "Error"
    return launchLabel
  }()
  // MARK: - Lifecycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setupUI()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func configure(with launch: Launch) {
    self.launch = launch
    self.launchName.text = launch.name
    self.patchImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
    self.patchImageView.sd_setImage(with: self.launch.imageUrl)
  }
  // MARK: - Setup UI
  private func setupUI() {
    self.addSubview(patchImageView)
    self.addSubview(launchName)
    patchImageView.translatesAutoresizingMaskIntoConstraints = false
    launchName.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      patchImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      patchImageView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
      patchImageView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.75),
      patchImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.75),
      launchName.leadingAnchor.constraint(equalTo: patchImageView.trailingAnchor, constant: 20),
      launchName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
      launchName.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    ])
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
      // Configure the view for the selected state
  }
}
