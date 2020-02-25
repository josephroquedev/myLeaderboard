import { Request } from 'express';
import Games from '../db/games';
import Players from '../db/players';
import Plays from '../db/plays';

export default async function hasUpdates(req: Request): Promise<boolean> {
    const since = new Date(req.query.since);
    return Games.getInstance().anyUpdatesSince(since)
        || Players.getInstance().anyUpdatesSince(since)
        || Plays.getInstance().anyUpdatesSince(since);
}
