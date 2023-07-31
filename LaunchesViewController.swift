//
//  ViewController.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 31.07.2023.
//

import UIKit
import SDWebImage

class LaunchesViewController: UIViewController {
  private var tableView: UITableView = {
    let launchTableView = UITableView()
    launchTableView.backgroundColor = .systemBackground
    launchTableView.register(LaunchViewCell.self, forCellReuseIdentifier: LaunchViewCell.sellIdentifier)
    return launchTableView
  }()
  var safeArea = UILayoutGuide()
  var launches: [Launch] = []
  let dateFormatter = DateFormatter()
  //MARK: - LifeCycle
  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchData()
    safeArea = view.layoutMarginsGuide
    configDateFromatter()
    setupTableView()

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

  func fetchData() {
    let xLaunchApi = XLaunchApi.fetchLaunches
    guard let request = xLaunchApi.request else {
      print("fail request")
      return
    }
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let error {
        print(error.localizedDescription)
      }


      if let data = data {
        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON  {
                print(responseJSON)
            }
        do {
          let decoder = JSONDecoder()
          // bdecoder.dateDecodingStrategy = .
          decoder.keyDecodingStrategy = .convertFromSnakeCase
          let document = try decoder.decode(Document.self, from: data)
          DispatchQueue.main.async {
            self.launches = document.docs
            self.tableView.reloadData()
          }
        } catch {
          print("cant decode data")
        }
      } else {
        print("unable to complete")
      }

    }
    task.resume()
  }
}

extension LaunchesViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return launches.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: LaunchViewCell.sellIdentifier, for: indexPath) as? LaunchViewCell else {
      fatalError("Unable to dequeue LaunchCell in LaunchesView Controller")
    }
    cell.configure(with: launches[indexPath.row])
    return cell
  }
}
