import { Request } from 'express';
import Players from '../db/players';
import Plays from '../db/plays';
import { isBanished } from '../lib/Freshness';
import { Game, GameRecord, Record } from '../lib/types';
import { parseID } from '../common/utils';
import DataLoader, { MyLeaderboardLoader } from '../graphql/DataLoader';

enum GameResult {
    WON,
    LOST,
    TIED,
}

interface RecordHighlight {
    player: number | undefined;
    winRate: number;
    losses: number;
    wins: number;
}

export default async function generateGameStandings(req: Request): Promise<GameRecord> {
    const gameId = parseID(req.params.id);
    const boardId = parseID(req.params.boardId);
    const loader = DataLoader();
    return gameStandings(gameId, boardId, false, loader);
}

export async function gameStandings(gameId: number, boardId: number, ignoreBanished: boolean, loader: MyLeaderboardLoader): Promise<GameRecord> {
    const game = await loader.gameLoader.load(gameId);

    const gameStandings = await buildStandings(game, boardId);
    const allPlayers = Players.getInstance().allIds({first: -1, offset: 0});
    const players = allPlayers.filter(id => {
        const playerRecord = gameStandings.records[id];
        return playerRecord == null ? false : ignoreBanished || isBanished(playerRecord) === false;
    });
    await highlightRecords(gameStandings, players, loader);

    return gameStandings;
}

async function buildStandings(game: Game, boardId: number): Promise<GameRecord> {
    const gameStandings: GameRecord = { records: {}};

    let totalGames = 0;
    let gamesWithScores = 0;
    let totalScore = 0;
    let bestScore = -Infinity;
    let worstScore = Infinity;

    const plays = Plays.getInstance().all({
        first: -1,
        offset: 0,
        filter: play => play.game === game.id && play.board === boardId,
    });
    plays.forEach(play => {
            totalGames += 1;
            if (game.hasScores && play.scores != null && play.scores.length > 1) {
                gamesWithScores += 1;
                for (const score of play.scores) {
                    totalScore += score;
                    if (score > bestScore) {
                        bestScore = score;
                    }
                    if (score < worstScore) {
                        worstScore = score;
                    }
                }

            }

            play.players.forEach((playerId, index) => {
                if (gameStandings.records[playerId] == null) {
                    gameStandings.records[playerId] = {
                        lastPlayed: play.playedOn,
                        overallRecord: { wins: 0, losses: 0, ties: 0 },
                        records: {},
                    };
                }

                if (game.hasScores && play.scores != null && play.scores.length > index) {
                    const playerScore = play.scores[index];
                    const playerStats = gameStandings.records[playerId].scoreStats;
                    if (playerStats == null) {
                        gameStandings.records[playerId].scoreStats = {
                            average: playerScore,
                            best: playerScore,
                            gamesPlayed: 1,
                            worst: playerScore,
                        };
                    } else {
                        playerStats.average += playerScore;
                        playerStats.gamesPlayed += 1;
                        if (playerScore > playerStats.best) {
                            playerStats.best = playerScore;
                        }
                        if (playerScore < playerStats.worst) {
                            playerStats.worst = playerScore;
                        }
                    }
                }

                const lastPlayed = gameStandings.records[playerId].lastPlayed;
                if (!lastPlayed || play.playedOn > lastPlayed) {
                    gameStandings.records[playerId].lastPlayed = play.playedOn;
                }

                let playerResult: GameResult;
                if (play.winners.length < play.players.length) {
                    if (play.winners.includes(playerId)) {
                        playerResult = GameResult.WON;
                        gameStandings.records[playerId].overallRecord.wins += 1;
                    } else {
                        gameStandings.records[playerId].overallRecord.losses += 1;
                        playerResult = GameResult.LOST;
                    }
                } else {
                    playerResult = GameResult.TIED;
                    gameStandings.records[playerId].overallRecord.ties += 1;
                }

                play.players.filter(opponent => opponent !== playerId)
                    .forEach(opponent => {
                        if (gameStandings.records[playerId].records[opponent] == null) {
                            gameStandings.records[playerId].records[opponent] = { wins: 0, losses: 0, ties: 0 };
                        }

                        if (playerResult === GameResult.WON) {
                            gameStandings.records[playerId].records[opponent].wins += 1;
                        } else if (playerResult === GameResult.LOST) {
                            gameStandings.records[playerId].records[opponent].losses += 1;
                        } else if (playerResult === GameResult.TIED) {
                            gameStandings.records[playerId].records[opponent].ties += 1;
                        }
                    });
            });
        });

    for (const player in gameStandings) {
        if (typeof(player) === 'number' && Object.prototype.hasOwnProperty.call(gameStandings, player)) {
            const playerStats = gameStandings.records[player].scoreStats;
            if (playerStats != null) {
                playerStats.average = playerStats.average / playerStats.gamesPlayed;
            }
        }
    }

    if (game.hasScores && totalScore > 0) {
        gameStandings.scoreStats = {
            average: totalScore / gamesWithScores,
            best: bestScore,
            gamesPlayed: totalGames,
            worst: worstScore,
        };
    }

    return gameStandings;
}

async function highlightRecords(standings: GameRecord, playerIds: Array<number>, loader: MyLeaderboardLoader): Promise<void> {
    const worstRecords: Array<RecordHighlight> = [{ player: undefined, winRate: Infinity, losses: 0, wins: 0 }];
    const bestRecords: Array<RecordHighlight> = [{ player: undefined, winRate: -Infinity, losses: 0, wins: 0 }];

    for (const playerId of playerIds) {
        const player = await loader.playerLoader.load(playerId);
        const playerDetails = standings.records[player.id];
        if (playerDetails == null) {
            continue;
        }

        const totalGames = playerDetails.overallRecord.wins + playerDetails.overallRecord.losses + playerDetails.overallRecord.ties;
        const winRate = Math.floor(playerDetails.overallRecord.wins / totalGames * 100);

        const playerRecordForHighlight = { player: player.id, winRate, losses: playerDetails.overallRecord.losses, wins: playerDetails.overallRecord.wins };
        updateHighlightedRecords(playerRecordForHighlight, bestRecords, worstRecords);

        const worstVsRecords: Array<RecordHighlight> = [{ player: undefined, winRate: Infinity, losses: 0, wins: 0 }];
        const bestVsRecords: Array<RecordHighlight> = [{ player: undefined, winRate: -Infinity, losses: 0, wins: 0 }];
        for (const opponentId of playerIds) {
            const vsRecord = playerDetails.records[opponentId.toString()];
            if (opponentId === player.id || vsRecord == null) {
                continue;
            }

            const vsTotalGames = vsRecord.wins + vsRecord.losses + vsRecord.ties;
            const vsWinRate = Math.floor(vsRecord.wins / vsTotalGames * 100);

            const vsRecordForHighlight = { player: opponentId, winRate: vsWinRate, losses: vsRecord.losses, wins: vsRecord.wins };
            updateHighlightedRecords(vsRecordForHighlight, bestVsRecords, worstVsRecords);
        }

        const playerVs: Map<number, Record> = new Map();
        for (const opponentId of playerIds) {
            if (opponentId === player.id) {
                continue;
            }

            playerVs.set(opponentId, playerDetails.records[opponentId]);
        }

        markBestAndWorstRecords(playerVs, bestVsRecords, worstVsRecords);
    }

    const playerTotals: Map<number, Record> = new Map();
    for (const playerId of playerIds) {
        playerTotals.set(playerId, standings.records[playerId].overallRecord);
    }
    markBestAndWorstRecords(playerTotals, bestRecords, worstRecords);
}

function updateHighlightedRecords(record: RecordHighlight, bestRecords: Array<RecordHighlight>, worstRecords: Array<RecordHighlight>): void {
    if (record.winRate > bestRecords[0].winRate) {
        bestRecords.length = 0;
        bestRecords.push(record);
    } else if (record.winRate === bestRecords[0].winRate) {
        if (record.wins > bestRecords[0].wins) {
            bestRecords.length = 0;
            bestRecords.push(record);
        } else if (record.wins === bestRecords[0].wins) {
            bestRecords.push(record);
        }
    }
    if (record.winRate < worstRecords[0].winRate) {
        worstRecords.length = 0;
        worstRecords.push(record);
    } else if (record.winRate === worstRecords[0].winRate) {
        if (record.losses > worstRecords[0].losses) {
            worstRecords.length = 0;
            worstRecords.push(record);
        } else if (record.losses === worstRecords[0].losses) {
            worstRecords.push(record);
        }
    }
}

function markBestAndWorstRecords(records: Map<number, Record>, bestRecords: Array<RecordHighlight>, worstRecords: Array<RecordHighlight>): void {
    for (const player of records.keys()) {
        const playerRecord = records.get(player);
        if (!playerRecord) {
            return;
        }

        for (const best of bestRecords) {
            if (best.player === player) {
                playerRecord.isBest = true;
                break;
            }
        }

        for (const worst of worstRecords) {
            if (worst.player === player) {
                playerRecord.isWorst = true;
                break;
            }
        }
    }
}
