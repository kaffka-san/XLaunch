//
//  SceneDelegate.swift
//  XLaunch
//
//  Created by Anastasia Lenina on 31.07.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    let launchViewController = LaunchesViewController(LaunchesViewModel())
    window?.rootViewController = UINavigationController(rootViewController: launchViewController)
    window?.makeKeyAndVisible()
  }
}
