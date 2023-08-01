//
//  EmptyView.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 01.08.2023.
//

import UIKit

class EmptyStateView: UIView {
  // MARK: - UI Components
  private let messageLabel = GFTitleLabel(textAlignment: .center, fontSize: 28)
  private let logoImageView = UIImageView()
  private var retryButton = UIButton()

  // MARK: - Delegate
  weak var delegate: RetryActionDelegate?

  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  convenience init() {
    self.init(frame: .zero)
  }

  // MARK: - Setter
  func setMessage(message: String) {
    messageLabel.text = message
  }

  // MARK: - Setup UI
  private func configure() {
    self.backgroundColor = .systemBackground
    addSubviews(messageLabel, logoImageView, retryButton)
    configureMessageLabel()
    configureLogoImageView()
    configureRetryButtonView()
  }

  private func configureMessageLabel() {
    messageLabel.numberOfLines = 3
    messageLabel.textColor = .secondaryLabel
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      messageLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 100),
      messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
      messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
      messageLabel.heightAnchor.constraint(equalToConstant: 200)
    ])
  }

  private func configureRetryButtonView() {
    retryButton.backgroundColor = .systemBlue
    retryButton.setTitle("Retry", for: .normal)
    retryButton.translatesAutoresizingMaskIntoConstraints = false
    retryButton.addTarget(self, action: #selector(retry), for: .touchUpInside)

    NSLayoutConstraint.activate([
      retryButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
      retryButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 80),
      retryButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -80),
      retryButton.heightAnchor.constraint(equalToConstant: 50)
    ])
  }
  private func configureLogoImageView() {
    logoImageView.image = UIImage(named: "image-placeholder")
    logoImageView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1),
      logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1),
      logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -70)
    ])
  }

// MARK: - Delegate method
  @objc func retry(sender: UIButton) {
    delegate?.didTapButton()
  }
}


class GFTitleLabel: UILabel {
  // MARK: - Init label
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
    self.init(frame: .zero)
    self.textAlignment = textAlignment
    self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
  }

  // MARK: - Setup UI
  private func configure() {
    textColor = .label
    adjustsFontSizeToFitWidth = true
    minimumScaleFactor = 0.9
    lineBreakMode = .byTruncatingTail
    translatesAutoresizingMaskIntoConstraints = false
  }
}

protocol RetryActionDelegate: AnyObject {
  func didTapButton()
}
