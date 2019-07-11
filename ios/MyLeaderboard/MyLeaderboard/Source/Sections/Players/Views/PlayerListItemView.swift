//
//  PlayerListItemView.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-11.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

typealias PlayerListItemCell = HostCell<PlayerListItemView, PlayerListItemState, LayoutMarginsTableItemLayout>

class PlayerListItemView: UIView {
	fileprivate let playerImage = UIImageView()
	fileprivate let displayName = UILabel()
	fileprivate let username = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
		prepareForReuse()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupView() {
		playerImage.contentMode = .scaleAspectFit
		playerImage.translatesAutoresizingMaskIntoConstraints = false

		displayName.textColor = .text
		displayName.translatesAutoresizingMaskIntoConstraints = false

		username.textColor = .textSecondary
		username.translatesAutoresizingMaskIntoConstraints = false

		addSubview(playerImage)
		addSubview(username)
		addSubview(displayName)

		NSLayoutConstraint.activate([
			playerImage.leadingAnchor.constraint(equalTo: leadingAnchor),
			playerImage.topAnchor.constraint(equalTo: topAnchor),
			playerImage.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
			playerImage.widthAnchor.constraint(equalToConstant: Metrics.Image.listIcon),
			playerImage.heightAnchor.constraint(equalToConstant: Metrics.Image.listIcon),

			displayName.topAnchor.constraint(equalTo: playerImage.topAnchor),
			displayName.leadingAnchor.constraint(equalTo: playerImage.trailingAnchor, constant: Metrics.Spacing.small),

			username.topAnchor.constraint(equalTo: displayName.bottomAnchor, constant: Metrics.Spacing.tiny),
			username.leadingAnchor.constraint(equalTo: displayName.leadingAnchor),
			username.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
			])
	}

	fileprivate func prepareForReuse() {
		playerImage.image = nil
		username.text = nil
		displayName.text = nil
	}
}

struct PlayerListItemState: Equatable {
	let player: Player

	static func updateView(_ view: PlayerListItemView, state: PlayerListItemState?) {
		guard let state = state else {
			view.prepareForReuse()
			return
		}

		view.displayName.text = state.player.displayName
		view.username.text = state.player.username

		ImageLoader.shared.fetch(string: state.player.avatar) { result in
			if case .success(let image) = result {
				view.playerImage.image = image
			}
		}
	}
}
