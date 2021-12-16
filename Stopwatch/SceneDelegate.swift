//
//  SceneDelegate.swift
//  Stopwatch
//
//  Created by Pedro Fernandez on 12/13/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = StopwatchViewController()
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // No-op
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // No-op
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // No-op
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // No-op
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // No-op
    }

}
