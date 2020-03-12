// Syrup auto-generated file
import Foundation

public extension MyLeaderboardAPI {
struct GameDetailsResponse: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Find a single game.
		public var game: Game?

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder

	public init(game: Game?) {
			self.game = game
			self.__typename = "Query"
	}

		// MARK: - Nested Types
			public struct Game: GraphApiResponse, Equatable {
		// MARK: - Response Fields
			/// Player vs player records, and score statistics for the game.
			public var standings: Standings
			/// Most recent plays of the game.
			public var recentPlays: [RecentPlays]
			/// Unique ID.
			public var id: GraphID {
				get {
					return asGameDetailsFragmentFragment.id
				}
				set {
					asGameDetailsFragmentFragment.id = newValue
				}
			}
			/// Name of the game.
			public var name: String {
				get {
					return asGameDetailsFragmentFragment.name
				}
				set {
					asGameDetailsFragmentFragment.name = newValue
				}
			}
			/// Indicates if the game includes score keeping.
			public var hasScores: Bool {
				get {
					return asGameDetailsFragmentFragment.hasScores
				}
				set {
					asGameDetailsFragmentFragment.hasScores = newValue
				}
			}
			/// Image for the game.
			public var image: String? {
				get {
					return asGameDetailsFragmentFragment.image
				}
				set {
					asGameDetailsFragmentFragment.image = newValue
				}
			}
			public var asGameDetailsFragmentFragment: MyLeaderboardAPI.GameDetailsFragment
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
			private enum CodingKeys: String, CodingKey {
				case __typename
					case standings
					case recentPlays
					case asGameDetailsFragmentFragment = "fragment:asGameDetailsFragmentFragment"
			}
			public init(from decoder: Decoder) throws {
				let container = try decoder.container(keyedBy: CodingKeys.self)
				self.__typename = try container.decode(String.self, forKey: .__typename)
					self.standings = try container.decode(Standings.self, forKey: .standings)
					self.recentPlays = try container.decode([RecentPlays].self, forKey: .recentPlays)
					do {
						self.asGameDetailsFragmentFragment = try MyLeaderboardAPI.GameDetailsFragment(from: decoder)
					} catch let originalError {
						do {
							self.asGameDetailsFragmentFragment = try container.decode(MyLeaderboardAPI.GameDetailsFragment.self, forKey: .asGameDetailsFragmentFragment)
						} catch {
								throw originalError
						}
					}
			}
		public init(standings: Standings, recentPlays: [RecentPlays], gameDetailsFragmentFragment: MyLeaderboardAPI.GameDetailsFragment) {
				self.standings = standings
				self.recentPlays = recentPlays
				self.asGameDetailsFragmentFragment = gameDetailsFragmentFragment
				self.__typename = "Game"
		}
			// MARK: - Nested Types
				public struct Standings: GraphApiResponse, Equatable {
			// MARK: - Response Fields
				/// General score stats for the game.
				public var scoreStats: MyLeaderboardAPI.GameDetailsStandingsFragment.ScoreStats? {
					get {
						return asGameDetailsStandingsFragmentFragment.scoreStats
					}
					set {
						asGameDetailsStandingsFragmentFragment.scoreStats = newValue
					}
				}
				/// Player vs player records.
				public var records: [MyLeaderboardAPI.GameDetailsStandingsFragment.Records] {
					get {
						return asGameDetailsStandingsFragmentFragment.records
					}
					set {
						asGameDetailsStandingsFragmentFragment.records = newValue
					}
				}
				public var asGameDetailsStandingsFragmentFragment: MyLeaderboardAPI.GameDetailsStandingsFragment
			// MARK: - Helpers
			public let __typename: String
			public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
			public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
				private enum CodingKeys: String, CodingKey {
					case __typename
						case asGameDetailsStandingsFragmentFragment = "fragment:asGameDetailsStandingsFragmentFragment"
				}
				public init(from decoder: Decoder) throws {
					let container = try decoder.container(keyedBy: CodingKeys.self)
					self.__typename = try container.decode(String.self, forKey: .__typename)
						do {
							self.asGameDetailsStandingsFragmentFragment = try MyLeaderboardAPI.GameDetailsStandingsFragment(from: decoder)
						} catch let originalError {
							do {
								self.asGameDetailsStandingsFragmentFragment = try container.decode(MyLeaderboardAPI.GameDetailsStandingsFragment.self, forKey: .asGameDetailsStandingsFragmentFragment)
							} catch {
									throw originalError
							}
						}
				}
			public init(gameDetailsStandingsFragmentFragment: MyLeaderboardAPI.GameDetailsStandingsFragment) {
					self.asGameDetailsStandingsFragmentFragment = gameDetailsStandingsFragmentFragment
					self.__typename = "GameStandings"
			}
		}
				public struct RecentPlays: GraphApiResponse, Equatable {
			// MARK: - Response Fields
				/// Unique ID.
				public var id: GraphID {
					get {
						return asRecentPlayFragmentFragment.id
					}
					set {
						asRecentPlayFragmentFragment.id = newValue
					}
				}
				/// Date and time the play was recorded.
				public var playedOn: Date {
					get {
						return asRecentPlayFragmentFragment.playedOn
					}
					set {
						asRecentPlayFragmentFragment.playedOn = newValue
					}
				}
				/// Scores for the game. Order is in respect to `players`.
				public var scores: [Int]? {
					get {
						return asRecentPlayFragmentFragment.scores
					}
					set {
						asRecentPlayFragmentFragment.scores = newValue
					}
				}
				/// Game that was played.
				public var game: MyLeaderboardAPI.RecentPlayFragment.Game {
					get {
						return asRecentPlayFragmentFragment.game
					}
					set {
						asRecentPlayFragmentFragment.game = newValue
					}
				}
				/// Players that played in the game.
				public var players: [MyLeaderboardAPI.RecentPlayFragment.Players] {
					get {
						return asRecentPlayFragmentFragment.players
					}
					set {
						asRecentPlayFragmentFragment.players = newValue
					}
				}
				/// Winners of the game.
				public var winners: [MyLeaderboardAPI.RecentPlayFragment.Winners] {
					get {
						return asRecentPlayFragmentFragment.winners
					}
					set {
						asRecentPlayFragmentFragment.winners = newValue
					}
				}
				public var asRecentPlayFragmentFragment: MyLeaderboardAPI.RecentPlayFragment
			// MARK: - Helpers
			public let __typename: String
			public static let customDecoder: JSONDecoder = MyLeaderboardAPI.customDecoder
			public static let customEncoder: JSONEncoder = MyLeaderboardAPI.customEncoder
				private enum CodingKeys: String, CodingKey {
					case __typename
						case asRecentPlayFragmentFragment = "fragment:asRecentPlayFragmentFragment"
				}
				public init(from decoder: Decoder) throws {
					let container = try decoder.container(keyedBy: CodingKeys.self)
					self.__typename = try container.decode(String.self, forKey: .__typename)
						do {
							self.asRecentPlayFragmentFragment = try MyLeaderboardAPI.RecentPlayFragment(from: decoder)
						} catch let originalError {
							do {
								self.asRecentPlayFragmentFragment = try container.decode(MyLeaderboardAPI.RecentPlayFragment.self, forKey: .asRecentPlayFragmentFragment)
							} catch {
									throw originalError
							}
						}
				}
			public init(recentPlayFragmentFragment: MyLeaderboardAPI.RecentPlayFragment) {
					self.asRecentPlayFragmentFragment = recentPlayFragmentFragment
					self.__typename = "Play"
			}
		}
	}
}
}
