//
//  EmptyView.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 01.08.2023.
//

import UIKit

class EmptyStateView: UIView {
  // MARK: - UI Components
  private let messageLabel = TitleLabel(textAlignment: .center, fontSize: 28)
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
  func setMessage(message: String, frame: CGRect) {
    self.frame = frame
    messageLabel.text = message
  }

  // MARK: - Setup UI
  private func configure() {
    self.backgroundColor = .systemBackground
    addSubview(messageLabel)
    addSubview(logoImageView)
    addSubview(retryButton)
    configureMessageLabel()
    configureLogoImageView()
    configureRetryButtonView()
  }

  private func configureMessageLabel() {
    messageLabel.numberOfLines = 3
    messageLabel.lineBreakStrategy = .standard
    messageLabel.textColor = .label
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      messageLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30),
      messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
      messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
      messageLabel.heightAnchor.constraint(equalToConstant: 80)
    ])
  }

  private func configureRetryButtonView() {
    retryButton.configuration = .filled()
    retryButton.configuration?.cornerStyle = .capsule
    retryButton.configuration?.baseBackgroundColor = .systemBlue
    retryButton.configuration?.baseForegroundColor = .label
    retryButton.setTitle("Retry", for: .normal)
    retryButton.translatesAutoresizingMaskIntoConstraints = false
    retryButton.addTarget(self, action: #selector(retry), for: .touchUpInside)

    NSLayoutConstraint.activate([
      retryButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
      retryButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 80  ),
      retryButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -80),
      retryButton.heightAnchor.constraint(equalToConstant: 50)
    ])
  }
  private func configureLogoImageView() {
    logoImageView.image = UIImage(named: "empty-state-logo")
    logoImageView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      logoImageView.widthAnchor.constraint(equalToConstant: 600),
      logoImageView.heightAnchor.constraint(equalToConstant: 600),
      logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      logoImageView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: -20)
    ])
  }

  // MARK: - Delegate method
  @objc func retry(sender: UIButton) {
    delegate?.didTapButton()
  }
}


class TitleLabel: UILabel {
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
    self.font = UIFont.preferredFont(forTextStyle: .headline)
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
