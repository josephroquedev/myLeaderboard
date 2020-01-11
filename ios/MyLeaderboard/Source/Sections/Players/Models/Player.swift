//
//  Player.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-11.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit

struct Player: Identifiable, Equatable, Codable, Hashable {
	let id: ID
	let avatar: String?
	let displayName: String
	let username: String

	static var missingPlayerAvatar: UIImage {
		return UIImage(named: "MissingPlayer")!
	}

	var qualifiedAvatar: Avatar? {
		if let avatar = avatar {
			return .url(avatar)
		}

		return nil
	}
}

extension Optional where Wrapped == Player {
	var qualifiedAvatar: Avatar? {
		switch self {
		case .some(let player):
			return player.qualifiedAvatar
		case .none:
			return .image(Player.missingPlayerAvatar.withTintColor(.textSecondary))
		}
	}
}

extension Player: Comparable {
	public static func < (lhs: Player, rhs: Player) -> Bool {
		if lhs.displayName != rhs.displayName {
			return lhs.displayName < rhs.displayName
		}
		return lhs.id < rhs.id
	}
}

extension Player {
	private static let preferredPlayerKey = "Settings.PreferredPlayer"

	static var preferred: Player? {
		get {
			if let data = UserDefaults.group.value(forKey: Player.preferredPlayerKey) as? Data,
				let player = try? JSONDecoder().decode(Player.self, from: data) {
				return player
			}

			return nil
		}
		set {
			if let data = try? JSONEncoder().encode(newValue) {
				UserDefaults.group.set(data, forKey: Player.preferredPlayerKey)
			} else if newValue == nil {
				UserDefaults.group.removeObject(forKey: Player.preferredPlayerKey)
			}
		}
	}
}