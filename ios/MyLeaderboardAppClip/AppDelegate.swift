//
//  AppDelegate.swift
//  MyLeaderboardAppClip
//
//  Created by Joseph Roque on 2020-06-24.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import myLeaderboardApi
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	// TODO: need to set to proper board id
	private lazy var recordPlayController = RecordPlayViewController(boardId: GraphID(rawValue: "0")) { _ in }

	private lazy var navigationController: UINavigationController = {
		UINavigationController(rootViewController: recordPlayController)
	}()

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		Theme.apply()

		let window = UIWindow(frame: UIScreen.main.bounds)
		window.rootViewController = navigationController
		window.makeKeyAndVisible()
		window.overrideUserInterfaceStyle = Theme.interfaceStyle
		self.window = window

		setupCompletionScreen()

		return true
	}

	func application(
		_ application: UIApplication,
		continue userActivity: NSUserActivity,
		restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
	) -> Bool {
		respondTo(userActivity)
		return true
	}

	private func respondTo(_ activity: NSUserActivity?) {
		guard let activity = activity,
			activity.activityType == NSUserActivityTypeBrowsingWeb,
			let incomingURL = activity.webpageURL,
			let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
			let endOfPath = components.path?.split(separator: "/").last else { return }

		let gameId = GraphID(rawValue: String(endOfPath))
		recordPlayController.selectGame(withId: gameId)
	}

	private func setupCompletionScreen() {
		recordPlayController.onSuccess = { _ in
			self.navigationController.pushViewController(PlayRecordedViewController(), animated: true)
		}
	}
}
