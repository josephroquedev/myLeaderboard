import {
    GraphQLObjectType,
    GraphQLSchema,
    GraphQLNonNull,
    GraphQLID,
    GraphQLList,
    GraphQLInt,
    GraphQLBoolean,
    GraphQLString
} from 'graphql'

import player from './schema/player';
import game from './schema/game';
import Players from '../db/players';
import Games from '../db/games';
import play from './schema/play';
import Plays from '../db/plays';
import playerStandings from './schema/playerStandings';
import { playerStandingsToGraphQL, gameStandingsToGraphQL, parseID, playToGraphQL } from '../common/utils';
import { playerRecord } from '../players/record';
import gameStandings from './schema/gameStandings';
import { gameStandings as generateGameStandings } from '../games/standings';
import { anyUpdatesSince } from '../misc/hasUpdates';
import { addGame } from '../games/new';
import { addPlayer } from '../players/new';
import { recordPlay } from '../plays/record';
import { MyLeaderboardLoader } from './dataloader';
import { ListArguments } from '../db/table';

interface QueryContext {
    loader: MyLeaderboardLoader;
}

interface ItemQueryArgs {
    id: string;
}

interface ListQueryArgs extends ListArguments {}

interface HasUpdatesQueryArgs {
    since: string;
}

let RootQuery = new GraphQLObjectType<any, QueryContext, any>({
    name: 'Query',
    description: 'Realize Root Query',
    fields: () => ({

        player: {
            type: player,
            args: {
                id: {
                    type: GraphQLNonNull(GraphQLID),
                }
            },
            resolve: async (_, {id}: ItemQueryArgs, {loader}) => loader.playerLoader.load(id),
        },

        players: {
            type: GraphQLNonNull(GraphQLList(player)),
            args: {
                first: {
                    type: GraphQLInt,
                },
                offset: {
                    type: GraphQLInt,
                }
            },
            resolve: async (_, {first, offset}: ListQueryArgs, {loader}) => {
                const players = await Players.getInstance().allWithAvatars({first, offset});
                for (const player of players) {
                    loader.playerLoader.prime(String(player.id), player);
                }
                return players;
            }
        },

        playerRecord: {
            type: playerStandings,
            args: {
                id: {
                    type: GraphQLID,
                },
                game: {
                    type: GraphQLID,
                },
            },
            resolve: async(_, {id, game}, {loader}) => {
                return playerStandingsToGraphQL(await playerRecord(id, game), loader)
            }
        },

        game: {
            type: game,
            args: {
                id: {
                    type: GraphQLNonNull(GraphQLID),
                }
            },
            resolve: async (_, {id}: ItemQueryArgs, {loader}) => loader.gameLoader.load(id),
        },

        games: {
            type: GraphQLNonNull(GraphQLList(game)),
            args: {
                first: {
                    type: GraphQLInt,
                },
                offset: {
                    type: GraphQLInt,
                }
            },
            resolve: async (_, {first, offset}: ListQueryArgs, {loader}) => {
                const games = await Games.getInstance().allWithImages({first, offset});
                for (const game of games) {
                    loader.gameLoader.prime(String(game.id), game);
                }
                return games;
            },
        },

        gameStandings: {
            type: gameStandings,
            args: {
                id: {
                    type: GraphQLID,
                },
            },
            resolve: async (_, {id}: ItemQueryArgs, {loader}) => {
                return gameStandingsToGraphQL(await generateGameStandings(parseID(id)), loader);
            },
        },

        play: {
            type: play,
            args: {
                id: {
                    type: GraphQLID,
                },
            },
            resolve: async (_, {id}: ItemQueryArgs, {loader}) => loader.playLoader.load(id),
        },

        plays: {
            type: GraphQLList(GraphQLNonNull(play)),
            args: {
                first: {
                    type: GraphQLInt,
                },
                offset: {
                    type: GraphQLInt,
                }
            },
            resolve: async (_, {first, offset}: ListQueryArgs, {loader}) => {
                const plays = await Plays.getInstance().all({first, offset});
                for (const play of plays) {
                    loader.playLoader.prime(String(play.id), play);
                }
                return plays;
            }
        },

        hasAnyUpdates: {
            type: GraphQLNonNull(GraphQLBoolean),
            args: {
                since: {
                    type: GraphQLString,
                },
            },
            resolve: async (_, {since}: HasUpdatesQueryArgs, {}) => anyUpdatesSince(new Date(since)),
        }
    }),
});

interface MutationContext {
    loader: MyLeaderboardLoader;
}

interface CreatePlayerArgs {
    displayName: string;
    username: string;
}

interface CreateGameArgs {
    name: string;
    hasScores: boolean;
}

interface RecordPlayArgs {
    players: Array<string>;
    winners: Array<string>;
    game: string;
    scores?: Array<number>;
}

let RootMutation = new GraphQLObjectType<any, MutationContext, any>({
    name: 'Mutation',
    description: 'Realize Root Mutation',
    fields: () => ({
        createPlayer: {
            type: player,
            args: {
                displayName: {
                    type: GraphQLNonNull(GraphQLString),
                },
                username: {
                    type: GraphQLNonNull(GraphQLString),
                },
            },
            resolve: async (_, {displayName, username}: CreatePlayerArgs, {}) => addPlayer(displayName, username),
        },

        createGame: {
            type: game,
            args: {
                name: {
                    type: GraphQLNonNull(GraphQLString),
                },
                hasScores: {
                    type: GraphQLNonNull(GraphQLBoolean),
                },
            },
            resolve: async (_, {name, hasScores}: CreateGameArgs, {}) => addGame(name, hasScores),
        },

        recordPlay: {
            type: play,
            args: {
                players: {
                    type: GraphQLNonNull(GraphQLList(GraphQLNonNull(GraphQLID))),
                },
                winners: {
                    type: GraphQLNonNull(GraphQLList(GraphQLNonNull(GraphQLID))),
                },
                game: {
                    type: GraphQLNonNull(GraphQLID),
                },
                scores: {
                    type: GraphQLList(GraphQLNonNull(GraphQLInt)),
                },
            },
            resolve: async (_, {players, winners, game, scores}: RecordPlayArgs, {loader}) => {
                return playToGraphQL(await recordPlay(
                    players.map(player => parseID(player)),
                    winners.map(winner => parseID(winner)),
                    scores,
                    parseID(game),
                ), loader);
            }
        }
    }),
});

export default new GraphQLSchema({
    query: RootQuery,
    mutation: RootMutation,
});
