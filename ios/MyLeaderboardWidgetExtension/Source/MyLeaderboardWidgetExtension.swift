//
//  MyLeaderboardWidgetExtension.swift
//  MyLeaderboardWidgetExtension
//
//  Created by Joseph Roque on 2020-06-22.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
	public func snapshot(
		with context: Context,
		completion: @escaping (SimpleEntry) -> Void
	) {
		let entry = SimpleEntry(date: Date())
		completion(entry)
	}

	public func timeline(
		with context: Context,
		completion: @escaping (Timeline<Entry>) -> Void
	) {
		var entries: [SimpleEntry] = []

		// Generate a timeline consisting of five entries an hour apart, starting from the current date.
		let currentDate = Date()
		for hourOffset in 0 ..< 5 {
			let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
			let entry = SimpleEntry(date: entryDate)
			entries.append(entry)
		}

		let timeline = Timeline(entries: entries, policy: .atEnd)
		completion(timeline)
	}
}

struct SimpleEntry: TimelineEntry {
	public let date: Date
}

struct PlaceholderView: View {
	var body: some View {
		Text("Placeholder View").foregroundColor(.blue)
	}
}

struct MyLeaderboardWidgetExtensionEntryView: View {
	var entry: Provider.Entry

	var body: some View {
		Text(entry.date, style: .time)
	}
}

@main
struct MyLeaderboardWidgetExtension: Widget {
	private let kind: String = "MyLeaderboardWidgetExtension"

	public var body: some WidgetConfiguration {
		StaticConfiguration(
			kind: kind,
			provider: Provider(),
			placeholder: PlaceholderView()
		) { entry in
			MyLeaderboardWidgetExtensionEntryView(entry: entry)
		}
		.configurationDisplayName("My Widget")
		.description("This is an example widget.")
		.supportedFamilies([.systemSmall, .systemMedium])
	}
}
