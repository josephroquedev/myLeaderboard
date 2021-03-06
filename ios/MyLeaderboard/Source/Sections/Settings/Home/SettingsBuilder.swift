//
//  SettingsBuilder.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-08-22.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import UIKit
import FunctionalTableData

protocol SettingsActionable: AnyObject {
	func changePreferredPlayer()
	func changePreferredOpponents()
	func changeBoard()
	func viewSource()
	func viewLicenses()
	func viewContributors()
	func nextInterfaceStyle()
}

enum SettingsBuilder {
	static func sections(
		currentBoard: BoardDetailsFragment?,
		preferredPlayer: PlayerListItem?,
		preferredOpponents: [PlayerListItem],
		interfaceStyle: UIUserInterfaceStyle,
		actionable: SettingsActionable
	) -> [TableSection] {
		return [
			boardSection(currentBoard: currentBoard, actionable: actionable),
			playerSection(preferredPlayer: preferredPlayer, actionable: actionable),
			opponentsSection(preferredOpponents: preferredOpponents, actionable: actionable),
			settingsSection(interfaceStyle: interfaceStyle, actionable: actionable),
			aboutSection(actionable: actionable),
		]
	}

	private static func boardSection(
		currentBoard: BoardDetailsFragment?,
		actionable: SettingsActionable
	) -> TableSection {
		var rows: [CellConfigType] = []

		if let currentBoard = currentBoard {
			let labelState = LabelState(
				text: .plain("Current board:"),
				textColor: .textSecondary,
				size: Metrics.Text.body
			)

			let boardState = LabelState(
				text: .plain(currentBoard.boardName),
				textColor: .text,
				size: Metrics.Text.body
			)

			rows.append(contentsOf: [
				Cells.header(key: "Header", title: "Board"),
				CombinedCell<UILabel, LabelState, UILabel, LabelState, LayoutMarginsTableItemLayout>(
					key: "current-board",
					style: CellStyle(highlight: true, accessoryType: .disclosureIndicator),
					actions: CellActions(selectionAction: { [weak actionable] _ in
						actionable?.changeBoard()
						return .deselected
					}),
					state: CombinedState(state1: labelState, state2: boardState),
					cellUpdater: { view, state in
						if state == nil {
							view.view1.setContentHuggingPriority(.defaultHigh, for: .horizontal)
							view.stackView.spacing = 0
						} else {
							view.view1.setContentHuggingPriority(.required, for: .horizontal)
							view.stackView.spacing = Metrics.Spacing.small
						}

						CombinedState<LabelState, LabelState>.updateView(view, state: state)
					}
				),
			])
		}

		return TableSection(key: "CurrentBoard", rows: rows)
	}

	private static func playerSection(
		preferredPlayer: PlayerListItem?,
		actionable: SettingsActionable
	) -> TableSection {
		let rows: [CellConfigType] = [
			Cells.header(key: "Header", title: "Preferred Player"),
			PlayerListItemCell(
				key: "Player",
				style: CellStyle(highlight: true, accessoryType: .disclosureIndicator),
				actions: CellActions(selectionAction: { [weak actionable] _ in
					actionable?.changePreferredPlayer()
					return .deselected
				}),
				state: PlayerListItemState(
					displayName: preferredPlayer?.displayName ?? "No player selected",
					username: preferredPlayer?.username ?? "Tap to choose...",
					avatar: preferredPlayer.qualifiedAvatar
				),
				cellUpdater: PlayerListItemState.updateView
			),
		]

		return TableSection(key: "PreferredPlayer", rows: rows)
	}

	private static func opponentsSection(
		preferredOpponents: [PlayerListItem],
		actionable: SettingsActionable
	) -> TableSection {
		var rows: [CellConfigType] = [
			Cells.header(key: "Header", title: "Opponents in Widget"),
		]

		rows.append(contentsOf: preferredOpponents.map {
			return PlayerListItemCell(
				key: "Opponent-\($0.id)",
				state: PlayerListItemState(
					displayName: $0.displayName,
					username: $0.username,
					avatar: $0.qualifiedAvatar
				),
				cellUpdater: PlayerListItemState.updateView
			)
		})

		rows.append(Cells.label(
			key: "ChangeOpponents",
			text: preferredOpponents.count == 0 ? "Add opponents" : "Change opponents",
			onAction: { [weak actionable] in
				actionable?.changePreferredOpponents()
			}
		))

		return TableSection(key: "PreferredOpponents", rows: rows)
	}

	private static func settingsSection(
		interfaceStyle: UIUserInterfaceStyle,
		actionable: SettingsActionable
	) -> TableSection {
		let rows: [CellConfigType] = [
			Cells.header(key: "Header", title: "Settings"),
			Cells.toggle(
				key: "InterfaceStyle",
				text: "Override interface style",
				option: interfaceStyle.stringValue
			) { [weak actionable] in
				actionable?.nextInterfaceStyle()
			},
		]

		return TableSection(key: "Settings", rows: rows)
	}

	private static func aboutSection(actionable: SettingsActionable) -> TableSection {
		let rows: [CellConfigType] = [
			Cells.header(key: "Header", title: "About"),
			Cells.label(key: "Source", text: "View source") { [weak actionable] in
				actionable?.viewSource()
			},
			Cells.label(key: "Licenses", text: "Licenses") { [weak actionable] in
				actionable?.viewLicenses()
			},
			Cells.label(key: "Contributors", text: "Contributors") { [weak actionable] in
				actionable?.viewContributors()
			},
			LabelCell(
				key: "AppInfo-Name",
				state: LabelState(
					text: .attributed(NSAttributedString(string: "MyLeaderboard", textColor: .textSecondary)),
					alignment: .right,
					size: Metrics.Text.caption
				),
				cellUpdater: LabelState.updateView
			),
			LabelCell(
				key: "AppInfo-Version",
				state: LabelState(
					text: .attributed(NSAttributedString(string: "iOS v\(appVersion())", textColor: .textSecondary)),
					alignment: .right,
					size: Metrics.Text.caption
				),
				cellUpdater: LabelState.updateView
			),
		]

		return TableSection(key: "About", rows: rows)
	}

	private static func appVersion() -> String {
		let dictionary = Bundle.main.infoDictionary!
		let version = dictionary["CFBundleShortVersionString"] as? String
		return version ?? ""
	}

	private enum Cells {
		static func header(key: String, title: String) -> CellConfigType {
			return LabelCell(
				key: key,
				style: CellStyle(backgroundColor: .primaryLight),
				state: LabelState(
					text: .attributed(NSAttributedString(string: title, textColor: .text)),
					size: Metrics.Text.title
				),
				cellUpdater: LabelState.updateView
			)
		}

		static func label(key: String, text: String, onAction: @escaping () -> Void) -> CellConfigType {
			return LabelCell(
				key: key,
				style: CellStyle(highlight: true, accessoryType: .disclosureIndicator),
				actions: CellActions(selectionAction: { _ in
					onAction()
					return .deselected
				}),
				state: LabelState(
					text: .attributed(NSAttributedString(string: text, textColor: .text)),
					size: Metrics.Text.body
				),
				cellUpdater: LabelState.updateView
			)
		}

		static func toggle(
			key: String,
			text: String,
			option: String,
			onAction: @escaping () -> Void
		) -> CellConfigType {
			return CombinedCell<UILabel, LabelState, UILabel, LabelState, LayoutMarginsTableItemLayout>(
				key: key,
				style: CellStyle(highlight: true),
				actions: CellActions(selectionAction: { _ in
					onAction()
					return .deselected
				}),
				state: CombinedState(
					state1: LabelState(
						text: .attributed(NSAttributedString(string: text, textColor: .text)),
						size: Metrics.Text.body
					),
					state2: LabelState(
						text: .attributed(NSAttributedString(string: option, textColor: .text)),
						size: Metrics.Text.body
					)
				),
				cellUpdater: CombinedState<LabelState, LabelState>.updateView
			)
		}
	}
}
