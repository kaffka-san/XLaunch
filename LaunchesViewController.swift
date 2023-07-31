//
//  ViewController.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 31.07.2023.
//

import UIKit
import SDWebImage

class LaunchesViewController: UIViewController {
  // MARK: - Variables
  private var launchesViewModel: LaunchesViewModel
  public var vSpinner: [UIView] = []
  let refreshControl = UIRefreshControl()
  private var tableView: UITableView = {
    let launchTableView = UITableView()
    launchTableView.backgroundColor = .systemBackground
    launchTableView.register(LaunchViewCell.self, forCellReuseIdentifier: LaunchViewCell.sellIdentifier)
    return launchTableView
  }()
  var safeArea = UILayoutGuide()
  let dateFormatter = DateFormatter()
  // MARK: - LifeCycle
  init(_ launchesViewModel: LaunchesViewModel) {
    self.launchesViewModel = launchesViewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    safeArea = view.layoutMarginsGuide
    configDateFromatter()
    setupTableView()
    refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
    refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
    tableView.addSubview(refreshControl)
    self.launchesViewModel.onLoadingsUpdated = { [weak self] in
      DispatchQueue.main.async { [weak self] in
        if self?.launchesViewModel.isLoading ?? false {
          self?.tableView.isHidden = true
          self?.showSpinner(onView: self?.view)
        } else {
          print("try to reload data end loading")
          self?.removeSpinner()
          self?.tableView.reloadData()
          self?.tableView.isHidden = false
        }
      }
    }
  }
  @objc func refresh() {
    launchesViewModel.fetchLaunches()
    print("trying to fetch")
    refreshControl.endRefreshing()
  }
  func setupTableView() {
    view.addSubview(tableView)
    tableView.rowHeight = 80
    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }

  func configDateFromatter() {
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    dateFormatter.locale = Locale.current
  }
}

extension LaunchesViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return launchesViewModel.launches.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: LaunchViewCell.sellIdentifier, for: indexPath) as? LaunchViewCell else {
      fatalError("Unable to dequeue LaunchCell in LaunchesView Controller")
    }
    cell.configure(with: launchesViewModel.launches[indexPath.row])
    return cell
  }
}
// MARK: - "Loading"
extension LaunchesViewController {
  func showSpinner(onView: UIView?) {
    guard let onView else { return }
    let spinnerView = UIView.init(frame: onView.bounds)
    //        spinnerView.backgroundColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.9)
    let activityIndicator = UIActivityIndicatorView.init(style: .medium)
    activityIndicator.startAnimating()
    activityIndicator.center = spinnerView.center

    DispatchQueue.main.async {
      spinnerView.addSubview(activityIndicator)
      onView.addSubview(spinnerView)
    }
    self.vSpinner.append(spinnerView)
  }

  func removeSpinner() {
    DispatchQueue.main.async {
      self.vSpinner.popLast()?.removeFromSuperview()
    }
  }
}
