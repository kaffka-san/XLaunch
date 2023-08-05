//
//  EmptyView.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 01.08.2023.
//

import UIKit

final class EmptyStateView: UIView {
  // MARK: - UI Components
  private let messageLabel = UILabel()
  private let logoImageView = UIImageView()
  private let retryButton = UIButton()

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
    messageLabel.lineBreakStrategy = .standard
    messageLabel.adjustsFontForContentSizeCategory = true
    messageLabel.textColor = .secondaryLabel
    messageLabel.textAlignment = .center
    messageLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
    messageLabel.adjustsFontSizeToFitWidth = true
    messageLabel.numberOfLines = 3

    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      messageLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30),
      messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
      messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
      messageLabel.heightAnchor.constraint(equalToConstant: 150 )
    ])
  }

  private func configureRetryButtonView() {
    retryButton.configuration = .filled()
    retryButton.configuration?.cornerStyle = .capsule
    retryButton.configuration?.baseBackgroundColor = .systemBlue
    retryButton.configuration?.baseForegroundColor = .white
    retryButton.setTitle(NSLocalizedString("EmptyView.RetryButton", comment: "Retry button name"), for: .normal)
    retryButton.addTarget(self, action: #selector(retry), for: .touchUpInside)

    retryButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      retryButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
      retryButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 80  ),
      retryButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -80),
      retryButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
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


protocol RetryActionDelegate: AnyObject {
  func didTapButton()
}
