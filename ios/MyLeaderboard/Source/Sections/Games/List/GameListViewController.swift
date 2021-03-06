//
//  GameListViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-06.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import myLeaderboardApi
import UIKit
import Loaf

class GameListViewController: FTDViewController {
	private var viewModel: GameListViewModel!

	init(boardId: GraphID) {
		super.init()
		refreshable = true
		paginated = true

		viewModel = GameListViewModel(boardId: boardId) { [weak self] action in
			guard let self = self else { return }
			switch action {
			case .dataChanged:
				self.finishRefresh()
				self.render()
			case .gameSelected(let game):
				self.showGameDetails(for: game)
			case .addGame:
				self.showCreateGame()
			case .graphQLError(let error):
				self.finishRefresh()
				self.presentError(error)
			}
		}
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.title = "Games"
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .add,
			target: self,
			action: #selector(addNewGame)
		)

		viewModel.postViewAction(.initialize)
		render()
	}

	private func render() {
		guard viewModel.games.count > 0 || !viewModel.dataLoading else {
			return tableData.renderAndDiff([LoadingCell.section()])
		}

		var sections = GameListBuilder.sections(games: viewModel.games, actionable: self)
		if viewModel.loadingMore {
			sections.append(LoadingCell.section(style: .medium, backgroundColor: .primary))
		}

		tableData.renderAndDiff(sections)
	}

	@objc private func addNewGame() {
		viewModel.postViewAction(.addGame)
	}

	private func showCreateGame() {
		presentModal(CreateGameViewController { [weak self] game in
			guard let self = self else { return }
			Loaf("\(game.name) created!", state: .success, sender: self).show()
			self.viewModel.postViewAction(.reload)
		})
	}

	private func showGameDetails(for gameID: GraphID) {
		let gameName = viewModel.games.first(where: { $0.id == gameID })?.name
		show(
			GameDetailsViewController(
				gameID: gameID,
				boardId: viewModel.boardId,
				withGameName: gameName
			),
			sender: self
		)
	}

	private func presentError(_ error: GraphAPIError) {
		Loaf(error.shortDescription, state: .error, sender: self).show()
	}

	override func refresh() {
		viewModel.postViewAction(.reload)
	}

	override func loadMore() {
		viewModel.postViewAction(.loadMore)
	}
}

extension GameListViewController: GameListActionable {
	func selectedGame(gameID: GraphID) {
		viewModel.postViewAction(.selectGame(gameID))
	}
}

extension GameListViewController: RouteHandler {
	func openRoute(_ route: Route) {
		guard case .gameDetails(let gameID) = route else {
			return
		}

		show(GameDetailsViewController(gameID: gameID, boardId: viewModel.boardId), sender: self)
	}
}
