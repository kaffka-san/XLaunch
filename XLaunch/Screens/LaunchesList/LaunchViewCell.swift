//
//  LaunchViewCell.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 31.07.2023.
//

import UIKit
import NukeUI

class LaunchViewCell: UITableViewCell {
  // MARK: - Variables
  static let cellIdentifier = "launchCell"

  // MARK: - UI Components
  private let patchImageView: LazyImageView = {
    let launchImageView = LazyImageView()
    launchImageView.contentMode = .scaleAspectFit
    launchImageView.imageView.image = UIImage(named: "image-placeholder")
    launchImageView.failureImage = UIImage(named: "image-placeholder")

    return launchImageView
  }()

  private let launchName: UILabel = {
    let launchLabel = UILabel()
    launchLabel.textColor = .label
    launchLabel.textAlignment = .left
    launchLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    launchLabel.adjustsFontSizeToFitWidth = true
    launchLabel.lineBreakStrategy = .standard
    launchLabel.numberOfLines = 2
    launchLabel.text = "Error"
    return launchLabel
  }()

  private let launchSubtitle: UILabel = {
    let launchSubtitle = UILabel()
    launchSubtitle.textColor = .secondaryLabel
    launchSubtitle.textAlignment = .left
    launchSubtitle.font = UIFont.preferredFont(forTextStyle: .subheadline)
    launchSubtitle.adjustsFontSizeToFitWidth = true
    launchSubtitle.numberOfLines = 3
    launchSubtitle.text = "Error"
    return launchSubtitle
  }()

  // MARK: - Init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setupUI()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Setup UI
  func configure(with launch: Launch, rowNum: Int) {
    self.launchName.text = "\(launch.name)"
    patchImageView.imageView.image = UIImage(named: "image-placeholder")
    let subtitle = NSLocalizedString("LaunchViewCell.subtitle", comment: "Subtitle in the cell")
    self.launchSubtitle.text = "\(subtitle) \(launch.flightNumber)\n\(launch.dateUtc.formatted(date: .abbreviated, time: .shortened))"

    if let imageUrl = launch.imageUrlSmall {
      patchImageView.placeholderView = UIActivityIndicatorView()
      patchImageView.priority = .high
      patchImageView.url = imageUrl
    }
  }

  // MARK: - Setup UI
  private func setupUI() {
    self.addSubview(patchImageView)
    self.addSubview(launchName)
    self.addSubview(launchSubtitle)

    patchImageView.translatesAutoresizingMaskIntoConstraints = false
    launchName.translatesAutoresizingMaskIntoConstraints = false
    launchSubtitle.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      patchImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      patchImageView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 10),
      patchImageView.widthAnchor.constraint(equalToConstant: 70),
      patchImageView.heightAnchor.constraint(equalToConstant: 70),

      launchName.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      launchName.leadingAnchor.constraint(equalTo: patchImageView.trailingAnchor, constant: 30),
      launchName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
      launchName.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4),

      launchSubtitle.topAnchor.constraint(equalTo: launchName.bottomAnchor, constant: 0),
      launchSubtitle.leadingAnchor.constraint(equalTo: patchImageView.trailingAnchor, constant: 30),
      launchSubtitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
      launchSubtitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
    ])
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
