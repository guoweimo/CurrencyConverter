//
//  AppDelegate.swift
//  CurrencyConverter
//
//  Created by Guowei Mo on 14/09/2018.
//  Copyright © 2018 Guowei Mo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    let vm = RatesViewModel(dispatcher: NetworkDispatcher(environment: .test))
    window?.rootViewController = RatesListViewController(viewModel: vm)
    window?.makeKeyAndVisible()
    return true
  }
}

