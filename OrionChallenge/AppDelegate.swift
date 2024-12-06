//
// OrionChallenge
// Copyright © 2024 Jean-Étienne Parrot. All rights reserved.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)

        let navigationController = UINavigationController(rootViewController: TabsCollectionViewController(viewModel: TabsCollectionViewModel()))
        navigationController.setNavigationBarHidden(true, animated: false)
        window.rootViewController = navigationController

        window.makeKeyAndVisible()
        self.window = window

        return true
    }

}
