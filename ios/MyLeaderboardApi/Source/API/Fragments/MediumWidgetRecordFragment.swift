// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
struct MediumWidgetRecordFragment: GraphApiResponse, Equatable {
	// MARK: - Response Fields
		/// Records against other players.
		public var records: [Records]

		/// Game the record represents.
		public var game: MyLeaderboardApi.SmallWidgetRecordFragment.Game {
			get {
				return asSmallWidgetRecordFragmentFragment.game
			}
			set {
				asSmallWidgetRecordFragmentFragment.game = newValue
			}
		}
		/// All time record for the player.
		public var overallRecord: MyLeaderboardApi.SmallWidgetRecordFragment.OverallRecord {
			get {
				return asSmallWidgetRecordFragmentFragment.overallRecord
			}
			set {
				asSmallWidgetRecordFragmentFragment.overallRecord = newValue
			}
		}

		public var asSmallWidgetRecordFragmentFragment: MyLeaderboardApi.SmallWidgetRecordFragment

	// MARK: - Helpers
	public let __typename: String

	public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
	public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder

		private enum CodingKeys: String, CodingKey {
			case __typename
				case records
				case asSmallWidgetRecordFragmentFragment = "fragment:asSmallWidgetRecordFragmentFragment"
		}

		public init(from decoder: Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.__typename = try container.decode(String.self, forKey: .__typename)
				self.records = try container.decode([Records].self, forKey: .records)
				do {
					self.asSmallWidgetRecordFragmentFragment = try MyLeaderboardApi.SmallWidgetRecordFragment(from: decoder)
				} catch let originalError {
					do {
						self.asSmallWidgetRecordFragmentFragment = try container.decode(MyLeaderboardApi.SmallWidgetRecordFragment.self, forKey: .asSmallWidgetRecordFragmentFragment)
					} catch {
							throw originalError
					}
				}
		}

	public init(records: [Records], smallWidgetRecordFragmentFragment: MyLeaderboardApi.SmallWidgetRecordFragment) {
			self.records = records
			self.asSmallWidgetRecordFragmentFragment = smallWidgetRecordFragmentFragment
			self.__typename = "PlayerGameRecord"
	}

		// MARK: - Nested Types
			public struct Records: GraphApiResponse, Equatable {
		// MARK: - Response Fields
			/// Player the record is against.
			public var opponent: Opponent
			/// Record against the opponent.
			public var record: Record
		// MARK: - Helpers
		public let __typename: String
		public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
		public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder
		public init(opponent: Opponent, record: Record) {
				self.opponent = opponent
				self.record = record
				self.__typename = "PlayerVSRecord"
		}
			// MARK: - Nested Types
				public struct Opponent: GraphApiResponse, Equatable {
			// MARK: - Response Fields
				/// Unique ID.
				public var id: GraphID {
					get {
						return asOpponentFragmentFragment.id
					}
					set {
						asOpponentFragmentFragment.id = newValue
					}
				}
				/// Avatar of the player.
				public var avatar: String? {
					get {
						return asOpponentFragmentFragment.avatar
					}
					set {
						asOpponentFragmentFragment.avatar = newValue
					}
				}
				/// Display name of the player.
				public var displayName: String {
					get {
						return asOpponentFragmentFragment.displayName
					}
					set {
						asOpponentFragmentFragment.displayName = newValue
					}
				}
				public var asOpponentFragmentFragment: MyLeaderboardApi.OpponentFragment
			// MARK: - Helpers
			public let __typename: String
			public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
			public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder
				private enum CodingKeys: String, CodingKey {
					case __typename
						case asOpponentFragmentFragment = "fragment:asOpponentFragmentFragment"
				}
				public init(from decoder: Decoder) throws {
					let container = try decoder.container(keyedBy: CodingKeys.self)
					self.__typename = try container.decode(String.self, forKey: .__typename)
						do {
							self.asOpponentFragmentFragment = try MyLeaderboardApi.OpponentFragment(from: decoder)
						} catch let originalError {
							do {
								self.asOpponentFragmentFragment = try container.decode(MyLeaderboardApi.OpponentFragment.self, forKey: .asOpponentFragmentFragment)
							} catch {
									throw originalError
							}
						}
				}
			public init(opponentFragmentFragment: MyLeaderboardApi.OpponentFragment) {
					self.asOpponentFragmentFragment = opponentFragmentFragment
					self.__typename = "BasicPlayer"
			}
		}
				public struct Record: GraphApiResponse, Equatable {
			// MARK: - Response Fields
				/// Number of wins.
				public var wins: Int {
					get {
						return asRecordFragmentFragment.wins
					}
					set {
						asRecordFragmentFragment.wins = newValue
					}
				}
				/// Number of losses.
				public var losses: Int {
					get {
						return asRecordFragmentFragment.losses
					}
					set {
						asRecordFragmentFragment.losses = newValue
					}
				}
				/// Number of ties.
				public var ties: Int {
					get {
						return asRecordFragmentFragment.ties
					}
					set {
						asRecordFragmentFragment.ties = newValue
					}
				}
				/// True if this represents the best record relative to similar records (of the player or the game).
				public var isBest: Bool? {
					get {
						return asRecordFragmentFragment.isBest
					}
					set {
						asRecordFragmentFragment.isBest = newValue
					}
				}
				/// True if this represents the worst record relative to similar records (of the player or the game).
				public var isWorst: Bool? {
					get {
						return asRecordFragmentFragment.isWorst
					}
					set {
						asRecordFragmentFragment.isWorst = newValue
					}
				}
				public var asRecordFragmentFragment: MyLeaderboardApi.RecordFragment
			// MARK: - Helpers
			public let __typename: String
			public static let customDecoder: JSONDecoder = MyLeaderboardApi.customDecoder
			public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder
				private enum CodingKeys: String, CodingKey {
					case __typename
						case asRecordFragmentFragment = "fragment:asRecordFragmentFragment"
				}
				public init(from decoder: Decoder) throws {
					let container = try decoder.container(keyedBy: CodingKeys.self)
					self.__typename = try container.decode(String.self, forKey: .__typename)
						do {
							self.asRecordFragmentFragment = try MyLeaderboardApi.RecordFragment(from: decoder)
						} catch let originalError {
							do {
								self.asRecordFragmentFragment = try container.decode(MyLeaderboardApi.RecordFragment.self, forKey: .asRecordFragmentFragment)
							} catch {
									throw originalError
							}
						}
				}
			public init(recordFragmentFragment: MyLeaderboardApi.RecordFragment) {
					self.asRecordFragmentFragment = recordFragmentFragment
					self.__typename = "Record"
			}
		}
	}
}
}
