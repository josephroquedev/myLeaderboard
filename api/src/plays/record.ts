import { Request } from 'express';
import { isPlayer } from '../common/utils';
import Plays from '../db/plays';
import { Play, Player } from '../lib/types';
import DataLoader, { MyLeaderboardLoader } from '../graphql/DataLoader';

export default async function record(req: Request): Promise<Play> {
    const playerIds: Array<number> = typeof(req.body.players) === 'string' ? JSON.parse(req.body.players) : req.body.players;
    const winnerIds: Array<number> = typeof(req.body.winners) === 'string' ? JSON.parse(req.body.winners) : req.body.winners;
    const scores: Array<number> | undefined = req.body.scores != null ? (typeof(req.body.scores) === 'string' ? JSON.parse(req.body.scores) : req.body.scores) : undefined;
    const board: number = req.body.board;
    const game: number = req.body.game;
    const loader = DataLoader();

    return recordPlay(playerIds, winnerIds, scores, game, board, loader);
}

export async function recordPlay(playerIds: Array<number>, winnerIds: Array<number>, scores: Array<number> | undefined, game: number, board: number, loader: MyLeaderboardLoader): Promise<Play> {
    if (playerIds.length === 0) {
        throw new Error('No players.');
    } else if (winnerIds.length === 0) {
        throw new Error('No winners.');
    }

    await validateGameExists(game, loader);
    await validatePlayersExist(playerIds, board, loader);
    await validateBoardExists(board, loader);
    validateWinnersExist(winnerIds, playerIds);

    const players = (await loader.playerLoader.loadMany(playerIds))
        .filter(player => isPlayer(player)) as Player[];

    const id = Plays.getInstance().getNextId();

    const newPlay = {
        game,
        board,
        id,
        playedOn: new Date().toISOString(),
        players: playerIds,
        winners: winnerIds,
        scores,
    };

    const playerList = players
            .map(player => player.username)
            .sort((first, second) => first.toLowerCase().localeCompare(second.toLowerCase()))
            .join(', ');

    Plays.getInstance().add(newPlay, `Recording game between ${playerList}`);

    return newPlay;
}

async function validatePlayersExist(winners: Array<number>, board: number, loader: MyLeaderboardLoader): Promise<void> {
    const players = await loader.playerLoader.loadMany(winners);
    for (const player of players) {
        if (!isPlayer(player) || player.board !== board) {
            throw player;
        }
    }
}

function validateWinnersExist(winners: Array<number>, players: Array<number>): void {
    for (const winnerId of winners) {
        let idFound = false;
        for (const playerId of players) {
            if (winnerId === playerId) {
                idFound = true;
                break;
            }
        }

        if (!idFound) {
            throw new Error(`Winner "${winnerId}" does not exist.`);
        }
    }
}

async function validateGameExists(id: number, loader: MyLeaderboardLoader): Promise<void> {
    await loader.gameLoader.load(id);
}

async function validateBoardExists(id: number, loader: MyLeaderboardLoader): Promise<void> {
    await loader.boardLoader.load(id);
}
