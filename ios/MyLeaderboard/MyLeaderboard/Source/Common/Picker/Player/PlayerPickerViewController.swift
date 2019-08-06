//
//  PlayerPickerViewController.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-02.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

struct PlayerListQueryable: PickerItemQueryable {
	func query(api: LeaderboardAPI, completion: @escaping (LeaderboardAPIResult<[Player]>) -> Void) {
		api.players(completion: completion)
	}
}

typealias PlayerPicker = BasePickerViewController<Player, PlayerCellState, PlayerListQueryable>

class PlayerPickerViewController: PlayerPicker {
	init(api: LeaderboardAPI, multiSelect: Bool = true, initiallySelected: Set<ID>, completion: @escaping PlayerPicker.FinishedSelection) {
		let queryable = PlayerListQueryable()
		super.init(api: api, initiallySelected: initiallySelected, multiSelect: multiSelect, queryable: queryable, completion: completion)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func renderItems(_ items: [Player]) -> [PickerItem<PlayerCellState>] {
		return items.map {
			return PickerItem(
				id: $0.id,
				state: Cells.playerState(for: $0)
			)
		}
	}
}
