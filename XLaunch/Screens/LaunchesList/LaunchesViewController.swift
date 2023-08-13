//
//  ViewController.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 31.07.2023.
//

import UIKit
import SwiftUI
import Combine

class LaunchesViewController: UIViewController {
  // MARK: - Variables
  private let launchesViewModel: LaunchesViewModel

  // MARK: - UI Components
  private let spinner: [UIView] = []
  private let genericEmptyStateView = EmptyStateView()
  private let searchController = UISearchController(searchResultsController: nil)
  private let refreshControl = UIRefreshControl()
  private let spinnerView = UIView()
  private let activityIndicator = UIActivityIndicatorView.init(style: .medium)
  private var subscriptions = Set<AnyCancellable>()
  private let tableView: UITableView = {
    let launchTableView = UITableView()
    launchTableView.backgroundColor = .systemBackground
    launchTableView.register(LaunchViewCell.self, forCellReuseIdentifier: LaunchViewCell.cellIdentifier)
    return launchTableView
  }()

  // MARK: - LifeCycle
  init(_ launchesViewModel: LaunchesViewModel) {
    self.launchesViewModel = launchesViewModel
    super.init(nibName: nil, bundle: nil)
    activityIndicator.center = view.center
    view.addSubview(activityIndicator)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupSearchBarListener()
    setupTableView()
    setupNavigationController()
    setupStateView()
    setupLaunchesViewState()
    setupRefreshControl()
    self.setupSearchController()
  }

  // MARK: - Update view on application state change
  func reloadData() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.refreshControl.endRefreshing()
      switch self.launchesViewModel.launchesViewState.value {
      case .error:
        prepareGenericEmptyView(
          with: launchesViewModel.error?.localizedDescription ?? LaunchServiceError.unknown.localizedDescription
        )
      case .empty:
        prepareGenericEmptyView(with: LaunchesViewState.empty.title)
      case .loading:
        genericEmptyStateView.removeFromSuperview()
        self.showSpinner()
      case .noResults:
        prepareGenericEmptyView(with: LaunchesViewState.noResults.title)
      case .data:
        genericEmptyStateView.removeFromSuperview()
        self.removeSpinner()
        self.tableView.reloadData()
      }
    }
  }

  func prepareGenericEmptyView(with message: String) {
    self.tableView.reloadData()
    self.removeSpinner()
    configureEmptyView(with: message)
  }

  func configureEmptyView(with message: String) {
    genericEmptyStateView.removeFromSuperview()
    genericEmptyStateView.setMessage(message: message, frame: view.bounds)
    view.insertSubview(genericEmptyStateView, aboveSubview: tableView)
  }

  private func setupSearchBarListener() {
    NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
      .compactMap { ($0.object as? UISearchTextField)?.text }
      .sink { [weak self] searchedText in
        self?.launchesViewModel.searchText.send(searchedText)
      }
      .store(in: &subscriptions)
  }

  private func setupLaunchesViewState() {
    launchesViewModel.launchesViewState.sink { [unowned self] _ in
      self.reloadData()
    }
    .store(in: &subscriptions)
  }

  // MARK: - Pull to refresh function
  @objc func refresh() {
    self.launchesViewModel.refresh()
  }

  // MARK: - Sorting action sheet
  @objc private func didTapListButton () {
    let alert = UIAlertController(
      title: NSLocalizedString(
        "ViewController.SortingParameters.Title",
        comment: "Sorting parameter title"),
      message: nil,
      preferredStyle: .actionSheet
    )

    alert.addAction(UIAlertAction(
      title: self.launchesViewModel.sortService.getNameLabelText(),
      style: .default
    ) { _ in
      self.launchesViewModel.sortParameter.send(.name)
    })
    alert.addAction(UIAlertAction(
      title: self.launchesViewModel.sortService.getFlightNumberLabelText(),
      style: .default) { _ in
        self.launchesViewModel.sortParameter.send(.flightNumber)
    })
    alert.addAction(UIAlertAction(
      title: self.launchesViewModel.sortService.getDateLabelText(),
      style: .default) { _ in
        //  self.launchesViewModel.sortLaunches(by: .date)
        self.launchesViewModel.sortParameter.send(.date)
    })
    alert.addAction(UIAlertAction(
      title: NSLocalizedString(
        "ViewController.SortingParameters.Action.Cancel",
        comment: "Cancel action for the sorting parameters"),
      style: .cancel,
      handler: nil)
    )

    self.present(alert, animated: true, completion: nil)
  }

  // MARK: - Setup UI
  func setupRefreshControl() {
    // refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
    refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
    tableView.addSubview(refreshControl)
  }

  func setupTableView() {
    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }

  private func setupNavigationController() {
    self.navigationItem.title = NSLocalizedString(
      "ViewController.NavigationTitle",
      comment: "Application name")
  }

  private func setupSearchController() {
    self.searchController.searchBar.placeholder = NSLocalizedString(
      "ViewController.SearchBar.Placeholder",
      comment: "Placeholder for the search bar"
    )

    self.searchController.searchBar.delegate = self
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "list.bullet"),
      style: .plain,
      target: self,
      action: #selector(didTapListButton)
    )

    self.navigationItem.searchController = searchController
    self.definesPresentationContext = false
    self.navigationItem.hidesSearchBarWhenScrolling = false
  }

  // MARK: - App state
  func setupStateView() {
    genericEmptyStateView.delegate = self
  }

  // MARK: - Update view.bounds for the Subview
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    DispatchQueue.main.async {
      if self.launchesViewModel.launchesViewState.value == .empty || self.launchesViewModel.launchesViewState.value == .noResults {
        self.configureEmptyView(with: self.launchesViewModel.launchesViewState.value.title)
      } else if self.launchesViewModel.launchesViewState.value == .error {
        self.configureEmptyView(
          with: self.launchesViewModel.error?.localizedDescription ??
          LaunchServiceError.unknown.localizedDescription)
      }
    }
  }
}

// MARK: - TableView functions
extension LaunchesViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return launchesViewModel.allLaunches.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: LaunchViewCell.cellIdentifier,
      for: indexPath) as? LaunchViewCell else {
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

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.tableView.deselectRow(at: indexPath, animated: true)
    let launch = self.launchesViewModel.allLaunches[indexPath.row]
    let detailLaunchViewModel = DetailLaunchViewModel(launch)
    let swiftUIView = DetailView(detailLaunchViewModel: detailLaunchViewModel) // swiftUIView is View
    let detailViewVC = UIHostingController(rootView: swiftUIView)
    self.navigationController?.pushViewController(detailViewVC, animated: true)
  }
}

// MARK: - Loading functions
extension LaunchesViewController {
  func showSpinner() {
    DispatchQueue.main.async {
      self.activityIndicator.startAnimating()
    }
  }
  func removeSpinner() {
    DispatchQueue.main.async {
      self.activityIndicator.stopAnimating()
    }
  }
}

// MARK: - Search controller Functions
extension LaunchesViewController: UISearchBarDelegate {
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    self.launchesViewModel.searchText.send("")
  }
}

// MARK: - Empty state Delegate
extension LaunchesViewController: RetryActionDelegate {
  func didTapButton() {
    self.launchesViewModel.refresh()
  }
}
