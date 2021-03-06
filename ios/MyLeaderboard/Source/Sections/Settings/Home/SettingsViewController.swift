//
//  SettingsViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-22.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import myLeaderboardApi
import UIKit
import Loaf

class SettingsViewController: FTDViewController {
	private var viewModel: SettingsViewModel!

	init(boardId: GraphID) {
		super.init()

		viewModel = SettingsViewModel(boardId: boardId) { [weak self] action in
			switch action {
			case .playerUpdated, .opponentsUpdated:
				self?.render()
			case .openURL(let url):
				self?.openURL(url)
			case .openPlayerPicker:
				self?.openPlayerPicker()
			case .openOpponentPicker:
				self?.openOpponentPicker()
			case .openBoardChanger:
				self?.openBoardChanger()
			case .openLicenses:
				self?.openLicenses()
			case .openContributors:
				self?.openContributors()
			case .updateInterfaceStyle:
				self?.updateInterfaceStyle()
			}
		}
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Settings"
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .done,
			target: self,
			action: #selector(finish)
		)

		viewModel.postViewAction(.initialize)
		render()
	}

	@objc private func finish() {
		dismiss(animated: true)
	}

	private func render() {
		let sections = SettingsBuilder.sections(
			currentBoard: viewModel.currentBoard,
			preferredPlayer: viewModel.preferredPlayer,
			preferredOpponents: viewModel.preferredOpponents,
			interfaceStyle: Theme.interfaceStyle,
			actionable: self
		)
		tableData.renderAndDiff(sections)
	}

	private func openURL(_ url: URL) {
		if UIApplication.shared.canOpenURL(url) {
			UIApplication.shared.open(url)
		}
	}

	private func openLicenses() {
		presentModal(LicensesListViewController())
	}

	private func openContributors() {
		presentModal(ContributorsListViewController())
	}

	private func openPlayerPicker() {
		let initiallySelected: Set<GraphID>
		if let player = viewModel.preferredPlayer {
			initiallySelected = [player.graphID]
		} else {
			initiallySelected = []
		}

		let playerPicker = PlayerPickerViewController(
			boardId: viewModel.boardId,
			multiSelect: false,
			initiallySelected: initiallySelected
		) { [weak self] selectedPlayers in
			self?.viewModel.postViewAction(.selectPreferredPlayer(selectedPlayers.first))
			self?.render()
		}
		presentModal(playerPicker)
	}

	private func openOpponentPicker() {
		let initiallySelected = Set(viewModel.preferredOpponents.map { $0.graphID })
		let opponentPicker = PlayerPickerViewController(
			boardId: viewModel.boardId,
			multiSelect: true,
			limit: Player.preferredOpponentsLimit,
			initiallySelected: initiallySelected
		) { [weak self] selectedOpponents in
			self?.viewModel.postViewAction(.selectPreferredOpponents(selectedOpponents))
			self?.render()
		}
		presentModal(opponentPicker)
	}

	private func openBoardChanger() {
		let changeController = ChangeBoardViewController { [weak self] board in
			self?.dismiss(animated: true)
			guard let board = board else { return }
			if let delegate = UIApplication.shared.delegate as? AppDelegate {
				delegate.window?.rootViewController = RootTabBarController(boardId: board.graphID)
			}
		}

		changeController.isModalInPresentation = true
		let controller = UINavigationController(rootViewController: changeController)

		DispatchQueue.main.async {
			self.present(controller, animated: true)
		}
	}

	private func updateInterfaceStyle() {
		switch Theme.interfaceStyle {
		case .dark: Theme.interfaceStyle = .light
		case .light: Theme.interfaceStyle = .unspecified
		case .unspecified: Theme.interfaceStyle = .dark
		@unknown default: Theme.interfaceStyle = .dark
		}

		if let delegate = UIApplication.shared.delegate as? AppDelegate {
			delegate.window?.overrideUserInterfaceStyle = Theme.interfaceStyle
		}

		render()
	}
}

extension SettingsViewController: SettingsActionable {
	func changePreferredPlayer() {
		viewModel.postViewAction(.editPlayer)
	}

	func changePreferredOpponents() {
		viewModel.postViewAction(.editOpponents)
	}

	func changeBoard() {
		viewModel.postViewAction(.changeBoard)
	}

	func viewSource() {
		viewModel.postViewAction(.viewSource)
	}

	func viewLicenses() {
		viewModel.postViewAction(.viewLicenses)
	}

	func viewContributors() {
		viewModel.postViewAction(.viewContributors)
	}

	func nextInterfaceStyle() {
		viewModel.postViewAction(.nextInterfaceStyle)
	}
}
