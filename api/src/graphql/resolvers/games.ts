import { Game, GameStandingsGraphQL } from "../../lib/types";
import Games from '../../db/games';
import { gameStandings } from "../../games/standings";
import { gameStandingsToGraphQL } from "../../common/utils";
import { addGame } from "../../games/new";

interface GameListQueryArguments {
    first: number;
    offset: number;
}

export async function resolveGames({first = 25, offset = 0}: GameListQueryArguments): Promise<Array<Game>> {
    const allGames = Games.getInstance().allWithImages();
    if (offset >= allGames.length) {
        return [];
    }

    return allGames.slice(offset, offset + first);
}

interface GameStandingsQueryArguments {
    id: number;
}

export async function resolveGameStandings({id}: GameStandingsQueryArguments): Promise<GameStandingsGraphQL> {
    const standings = await gameStandings(id);
    return gameStandingsToGraphQL(standings);
}

interface CreateGameArguments {
    name: string;
    hasScores: boolean;
}

export async function resolveCreateGame({name, hasScores}: CreateGameArguments): Promise<Game> {
    return addGame(name, hasScores);
}