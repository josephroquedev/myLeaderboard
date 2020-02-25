import { GraphQLDateTime } from 'graphql-iso-date';
import {
    resolvePlayers as players,
    resolvePlayerRecord as playerRecord,
    resolveCreatePlayer as createPlayer,
} from './players';
import {
    resolveGames as games,
    resolveGameStandings as gameStandings
} from './games';
import { resolveHasAnyUpdates as hasAnyUpdates } from './misc';
import { resolvePlays as plays } from './plays';

const resolvers = {
    DateTime: GraphQLDateTime,
    players,
    playerRecord,
    createPlayer,
    games,
    gameStandings,
    hasAnyUpdates,
    plays,
};

export default resolvers;