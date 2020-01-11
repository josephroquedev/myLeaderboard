//
//  PlayerListViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-11.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import Loaf

class PlayerListViewController: FTDViewController {
	private var api: LeaderboardAPI
	private var viewModel: PlayerListViewModel!

	init(api: LeaderboardAPI) {
		self.api = api
		super.init()
		refreshable = true
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel = PlayerListViewModel(api: api) { [weak self] action in
			guard let self = self else { return }
			switch action {
			case .playersUpdated:
				self.finishRefresh()
				self.render()
			case .playerSelected(let player):
				self.showPlayerDetails(for: player)
			case .apiError(let error):
				self.presentError(error)
			case .addPlayer:
				self.showCreatePlayer()
			}
		}

		self.title = "Players"
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPlayer))

		viewModel.postViewAction(.initialize)
		render()
	}

	private func render() {
		let sections = PlayerListBuilder.sections(players: viewModel.players, actionable: self)
		tableData.renderAndDiff(sections)
	}

	@objc private func addNewPlayer() {
		viewModel.postViewAction(.addPlayer)
	}

	private func showCreatePlayer() {
		presentModal(CreatePlayerViewController(api: api) { player in
			Loaf("\(player.displayName) added!", state: .success, sender: self).show()
		})
	}

	private func showPlayerDetails(for player: Player) {
		show(PlayerDetailsViewController(api: api, player: player), sender: self)
	}

	private func presentError(_ error: LeaderboardAPIError) {
		let message: String
		if let errorDescription = error.errorDescription {
			message = errorDescription
		} else {
			message = "Unknown error."
		}

		Loaf(message, state: .error, sender: self).show()
	}

	override func refresh() {
		viewModel.postViewAction(.reload)
	}
}

extension PlayerListViewController: PlayerListActionable {
	func selectedPlayer(player: Player) {
		viewModel.postViewAction(.selectPlayer(player))
	}
}

extension PlayerListViewController: RouteHandler {
	func openRoute(_ route: Route) {
		guard case .playerDetails(let playerID) = route else {
			return
		}

		show(PlayerDetailsViewController(api: api, playerID: playerID), sender: self)
	}
}