//
//  StandingsListViewModel.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-17.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

enum StandingsListAction: BaseAction {
	case standingsUpdated
	case playersUpdated
	case apiError(LeaderboardAPIError)
	case openRecordPlay
	case openGameDetails(Game)
	case openPlayerDetails(Player)
}

enum StandingsListViewAction: BaseViewAction {
	case initialize
	case reload
	case recordPlay
	case selectGame(Game)
	case selectPlayer(Player)
}

class StandingsListViewModel: ViewModel {
	typealias ActionHandler = (_ action: StandingsListAction) -> Void

	private var api: LeaderboardAPI
	var handleAction: ActionHandler

	private(set) var standings: [Game: Standings?] = [:] {
		didSet {
			handleAction(.standingsUpdated)
		}
	}

	private(set) var players: [Player] = [] {
		didSet {
			handleAction(.playersUpdated)
		}
	}

	init(api: LeaderboardAPI, handleAction: @escaping ActionHandler) {
		self.api = api
		self.handleAction = handleAction
	}

	func postViewAction(_ viewAction: StandingsListViewAction) {
		switch viewAction {
		case .initialize:
			loadData()
		case .reload:
			reloadData()
		case .recordPlay:
			handleAction(.openRecordPlay)
		case .selectGame(let game):
			handleAction(.openGameDetails(game))
		case .selectPlayer(let player):
			handleAction(.openPlayerDetails(player))
		}
	}

	private func reloadData() {
		api.refresh { [weak self] in
			switch $0 {
			case .failure(let error):
				self?.handleAction(.apiError(error))
			case .success:
				self?.loadData()
			}
		}
	}

	private func loadData() {
		api.games { [weak self] in
			switch $0 {
			case .failure(let error):
				self?.handleAction(.apiError(error))
			case .success(let games):
				self?.loadStandings(for: games)
			}
		}

		api.players { [weak self] in
			switch $0 {
			case .failure(let error):
				self?.handleAction(.apiError(error))
			case .success(let players):
				self?.players = players.sorted()
			}
		}
	}

	private func loadStandings(for games: [Game]) {
		games.forEach {
			standings[$0] = nil

			api.standings(for: $0) { [weak self] result in
				switch result {
				case .failure(let error):
					self?.handleAction(.apiError(error))
				case .success((let game, let standings)):
					self?.standings[game] = standings
				}
			}
		}
	}
}