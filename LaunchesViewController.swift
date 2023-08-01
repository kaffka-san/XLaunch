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

  // MARK: - UI Components
  private var spinner: [UIView] = []
  private var genericEmptyStateView = EmptyStateView()
  private let searchController = UISearchController(searchResultsController: nil)
  private let refreshControl = UIRefreshControl()
  private var tableView: UITableView = {
    let launchTableView = UITableView()
    launchTableView.backgroundColor = .systemBackground
    launchTableView.register(LaunchViewCell.self, forCellReuseIdentifier: LaunchViewCell.sellIdentifier)
    return launchTableView
  }()

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
    setupTableView()
    setupNavigationController()
    setupStateView()
    setUpRefreshControl()
    self.setupSearchController()
    self.launchesViewModel.onLoadingsUpdated = { [weak self] in
      self?.reloadData()
    }
  }

  // MARK: - Update view on application state change
  func reloadData() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      switch self.launchesViewModel.applicationState {
      case .error:
        genericEmptyStateView.removeFromSuperview()
        genericEmptyStateView.setMessage(message: "Error")
        view.insertSubview(genericEmptyStateView, aboveSubview: tableView)
        self.removeSpinner()
        print("error")
      case .empty:
        genericEmptyStateView.removeFromSuperview()
        genericEmptyStateView.setMessage(message: "No launches to show 🚀")
        view.insertSubview(genericEmptyStateView, aboveSubview: tableView)
        self.removeSpinner()
        print("empty")
      case .loading:
        genericEmptyStateView.removeFromSuperview()
        self.showSpinner(onView: self.view)
        print("loading")
      case .noResults:
        self.tableView.reloadData()
        genericEmptyStateView.removeFromSuperview()
        self.removeSpinner()
        genericEmptyStateView.setMessage(message: "No results 👀")
        view.insertSubview(genericEmptyStateView, aboveSubview: tableView)
        print("no res")

      case .data:
        genericEmptyStateView.removeFromSuperview()
        self.removeSpinner()
        self.tableView.reloadData()
        print("data")
      }
    }
  }

  // MARK: - Pull to refresh function
  @objc func refresh() {
    launchesViewModel.page = 1
    launchesViewModel.fetchLaunches()
    refreshControl.endRefreshing()
  }

  // MARK: - Sorting action sheet
  @objc private func didTapListButton () {
    let alert = UIAlertController(title: "Please choose preferable sorting parameter", message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: self.launchesViewModel.sortService.getNameLabelText(), style: .default) { _ in
      self.launchesViewModel.sortLaunches(by: .name)
    })
    alert.addAction(UIAlertAction(title: self.launchesViewModel.sortService.getFlightNumberLabelText(), style: .default) { _ in
      self.launchesViewModel.sortLaunches(by: .flightNumber)
    })
    alert.addAction(UIAlertAction(title: self.launchesViewModel.sortService.getDateLabelText(), style: .default) { _ in
      self.launchesViewModel.sortLaunches(by: .date)
    })
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

    self.present(alert, animated: true, completion: nil)
  }

  // MARK: - Setup UI
  func setUpRefreshControl() {
    refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
    refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
    tableView.addSubview(refreshControl)
  }
  func setupTableView() {
    view.addSubview(tableView)
    tableView.rowHeight = 100
    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }

  private func setupNavigationController() {
    self.navigationItem.title = "Space-X launches"
    // self.navigationController?.toolbar.backgroundColor = .systemBackground
  }

  private func setupSearchController() {
    self.searchController.searchResultsUpdater = self
    self.searchController.obscuresBackgroundDuringPresentation = false
    self.searchController.hidesNavigationBarDuringPresentation = true
    self.searchController.searchBar.placeholder = "Search for launches"
    self.searchController.searchBar.delegate = self
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(didTapListButton))
    self.navigationItem.searchController = searchController
    self.definesPresentationContext = false
    self.navigationItem.hidesSearchBarWhenScrolling = false
  }

  // MARK: - App state
  func setupStateView() {
    genericEmptyStateView.delegate = self
    genericEmptyStateView.frame = view.bounds
  }
}

// MARK: - TableView functions
extension LaunchesViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return launchesViewModel.allLaunches.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: LaunchViewCell.sellIdentifier, for: indexPath) as? LaunchViewCell else {
      fatalError("Unable to dequeue LaunchCell in LaunchesView Controller")
    }
    cell.configure(with: launchesViewModel.allLaunches[indexPath.row], rowNum: indexPath.row )
    return cell
  }
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == launchesViewModel.allLaunches.count - 1 {
      self.launchesViewModel.loadMoreData()
      refreshControl.endRefreshing()
    }
  }
}

// MARK: - Loading functions
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
    self.spinner.append(spinnerView)
  }

  func removeSpinner() {
    DispatchQueue.main.async {
      self.spinner.popLast()?.removeFromSuperview()
    }
  }
}

// MARK: - Search controller Functions
extension LaunchesViewController: UISearchResultsUpdating, UISearchBarDelegate {
  func updateSearchResults(for searchController: UISearchController) {
    self.launchesViewModel.searchText(textString: searchController.searchBar.text)
  }
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    self.launchesViewModel.searchText(textString: "")
  }
}

// MARK: - Empty state Delegate
extension LaunchesViewController: RetryActionDelegate {
  func didTapButton() {
    self.launchesViewModel.fetchLaunches()
  }
}
