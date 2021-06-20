//
//  GameDetailsViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-21.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Combine
import Foundation
import myLeaderboardApi

enum GameDetailsAction: BaseAction {
	case dataChanged
	case playerSelected(GraphID)
	case graphQLError(MyLeaderboardAPIError)
	case openPlays(PlayListFilter)
}

enum GameDetailsViewAction: BaseViewAction {
	case initialize
	case reload
	case selectPlayer(GraphID)
	case showPlays(PlayListFilter)
}

class GameDetailsViewModel: ViewModel {
	typealias GameDetailsQuery = MyLeaderboardApi.GameDetailsQuery
	typealias ActionHandler = (_ action: GameDetailsAction) -> Void

	let boardId: GraphID
	var handleAction: ActionHandler

	private(set) var dataLoading: Bool = false {
		didSet {
			handleAction(.dataChanged)
		}
	}

	private(set) var gameID: GraphID
	private(set) var game: GameDetails?
	private(set) var plays: [RecentPlay] = []
	private(set) var players: [Opponent] = []
	private(set) var standings: GameDetailsStandings?

	private var cancellable: AnyCancellable?

	init(gameID: GraphID, boardId: GraphID, handleAction: @escaping ActionHandler) {
		self.gameID = gameID
		self.boardId = boardId
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: GameDetailsViewAction) {
		switch viewAction {
		case .initialize, .reload:
			loadData()
		case .selectPlayer(let player):
			handleAction(.playerSelected(player))
		case .showPlays(let filter):
			handleAction(.openPlays(filter))
		}
	}

	private func loadData(retry: Bool = true) {
		self.dataLoading = true

		let query = GameDetailsQuery(id: gameID, board: boardId, ignoreBanished: true)
		cancellable = MLApi.shared.fetch(query: query)
			.sink(receiveCompletion: { [weak self] result in
				if case let .failure(error) = result, let graphError = error.graphQLError {
					self?.handleAction(.graphQLError(graphError))
				}

				self?.dataLoading = false
			}, receiveValue: { [weak self] value in
				guard let response = value.response else { return }
				self?.handle(response: response)
			})
	}

	private func handle(response: MyLeaderboardApi.GameDetailsResponse) {
		guard let game = response.game?.asGameDetailsFragmentFragment else {
			return handleAction(.graphQLError(.missingData))
		}

		self.game = game
		self.players = response.game?.standings.records.map { $0.player.asOpponentFragmentFragment } ?? []
		self.standings = response.game?.standings.asGameDetailsStandingsFragmentFragment
		self.plays = response.game?.recentPlays.map { $0.asRecentPlayFragmentFragment } ?? []
	}
}
