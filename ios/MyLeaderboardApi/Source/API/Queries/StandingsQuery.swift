// Syrup auto-generated file
import Foundation

public extension MyLeaderboardApi {
	struct StandingsQuery: GraphApiQuery, ResponseAssociable, Equatable {
		// MARK: - Query Variables
			public let board: GraphID
			public let first: Int
			public let offset: Int

		// MARK: - Initializer
		public init(board: GraphID, first: Int, offset: Int) {
				self.board = board
				self.first = first
				self.offset = offset
		}

		// MARK: - Helpers

		public static let customEncoder: JSONEncoder = MyLeaderboardApi.customEncoder

		private enum CodingKeys: CodingKey {
				case board
				case first
				case offset
		}

		public typealias Response = StandingsResponse

		public let queryString: String = """
		fragment StandingsGameFragment on Game { __typename id name image } fragment StandingsFragment on Game { __typename standings(board: $board) { __typename records { __typename ... StandingsPlayerRecordFragment } } } fragment StandingsPlayerRecordFragment on PlayerRecord { __typename player { __typename ... OpponentFragment } record { __typename ... StandingsPlayerGameRecordFragment } } fragment OpponentFragment on BasicPlayer { __typename id avatar displayName } fragment StandingsPlayerGameRecordFragment on PlayerGameRecord { __typename lastPlayed overallRecord { __typename ... RecordFragment } records { __typename opponent { __typename ... OpponentFragment } record { __typename ... RecordFragment } } } fragment RecordFragment on Record { __typename wins losses ties isBest isWorst } query Standings($board: ID!, $first: Int!, $offset: Int!) { __typename games(first: $first, offset: $offset) { __typename ... StandingsGameFragment ... StandingsFragment } }
		"""
	}
}


extension MyLeaderboardApi.StandingsQuery {
  public static let operationSelections: GraphSelections.Operation? = nil
}
