//
//  LaunchViewCell.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 31.07.2023.
//

import UIKit
import Nuke
import NukeUI
import NukeExtensions

class LaunchViewCell: UITableViewCell {
  // MARK: - Variables
  static let sellIdentifier = "launchCell"
  private var launch: Launch!

  // MARK: - UI Components
  private var patchImageView: UIImageView = {
    let launchImageView = UIImageView()
    launchImageView.contentMode = .scaleAspectFit
    launchImageView.image = UIImage(named: "image-placeholder")
    return launchImageView
  }()

  private var launchName: UILabel = {
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
  private var launchSubtitle: UILabel = {
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
    self.launch = launch
    self.patchImageView.image = UIImage(named: "image-placeholder")
    self.launchName.text = "\(launch.name)"
    self.launchSubtitle.text = "Flight number: \(String(describing: launch.flightNumber))\n\(launch.dateUnix.formatted(date: .abbreviated, time: .shortened))"
    if let imageUrl = self.launch.imageUrl {
      ImagePipeline.shared.loadImage(with: imageUrl) { [weak self] response in
        guard let self = self else {
          return
        }
        switch response {
        case .failure:
          self.patchImageView.image = UIImage(named: "image-placeholder")
          self.patchImageView.contentMode = .scaleAspectFit
        case let .success(imageResponse):
          self.patchImageView.image = imageResponse.image
          self.patchImageView.contentMode = .scaleAspectFill
        }
      }
      DataLoader.sharedUrlCache.diskCapacity = 0
      let pipeline = ImagePipeline {
        let dataCache = try? DataCache(name: imageUrl.absoluteString)
        dataCache?.sizeLimit = 200 * 1024 * 1024
        $0.dataCache = dataCache
      }
      ImagePipeline.shared = pipeline
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
    // Configure the view for the selected state
  }
}
