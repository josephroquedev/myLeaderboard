// tslint:disable

// @ts-ignore: Common module in api/dashboard
import * as Octokat from 'octokat';
// @ts-ignore: Common module in api/dashboard
import { base64decode, base64encode } from '../common/Base64';
import { allGames } from './Game';
import { BasicPlayer, BasicGamePlayer, GameStandings, GitHubUser, GenericPlayer } from './types';

interface Blob {
    content: string;
    path: string;
    sha: string;
}

interface Author {
    name: string;
    email: string;
    date: string;
}

interface Commit {
    author: Author;
    committer: Author;
    message: string;
}

interface CommitItem {
    sha: string;
    commit: Commit;
}

interface Content {
    type: string;
    name: string;
}

export interface Writeable {
    path: string;
    sha?: string;
    content: string;
    message?: string;
}

class Octo {
    public static setToken(token: string | undefined) {
        Octo.token = token;
        Octo.instance = undefined;
    }

    public static setBranch(branch: string) {
        Octo.branch = branch;
    }

    public static getInstance(): Octo {
        if (Octo.instance == null) {
            Octo.instance = new Octo(Octo.token);
        }

        return Octo.instance;
    }

    private static instance: Octo | undefined;
    private static branch: string = 'master';
    private static token: string | undefined;

    private octo: any;
    private repo: any;

    private constructor(token: string | undefined) {
        // @ts-ignore Octokat isn't playing nice with TS, so ignore the error that it's not a constructor.
        this.octo = Octokat.default({ token });
        this.repo = this.octo.repos('josephroquedev', 'myLeaderboard');
    }

    // Users

    public async players(forGame: string | undefined = undefined): Promise<Array<GenericPlayer>> {
        const playerUsernames: Set<string> = new Set();
        const basicPlayers: Array<BasicPlayer> = [];

        let games: Array<string>;
        if (forGame == null) {
            games = await allGames();
        } else {
            games = [forGame];
        }

        for (const game of games) {
            const gamePlayers = await this.playersForGame(game);
            for (const gamePlayer of gamePlayers) {
                if (playerUsernames.has(gamePlayer.username) === false) {
                    playerUsernames.add(gamePlayer.username);
                    basicPlayers.push(gamePlayer);
                }
            }
        }

        const promises: Array<Promise<GitHubUser>> = [];
        for (const basicPlayer of basicPlayers) {
            promises.push(this.user(basicPlayer.username));
        }

        const users = await Promise.all(promises);

        const players: Array<GenericPlayer> = [];
        for (let i = 0; i < basicPlayers.length; i++) {
            players.push({
                avatar: users[i].avatarUrl,
                displayName: basicPlayers[i].displayName,
                username: basicPlayers[i].username,
            });
        }
        return players;
    }

    private async playersForGame(game: string): Promise<Array<BasicGamePlayer>> {
        const contents = await this.contents(`data/${game}.json`);
        const standings: GameStandings = JSON.parse(contents);
        return standings.players;
    }

    public async user(name: string): Promise<GitHubUser> {
        if (name.charAt(0) === '@') {
            name = name.substr(1);
        }

        return await this.octo.users(name).fetch();
    }

    // Contents

    public async dir(path: string): Promise<Array<Content>> {
        const dirContents = await this.repo.contents(path).read({ ref: Octo.branch });
        return dirContents.items;
    }

    public async contents(filename: string): Promise<string> {
        return await this.repo.contents(filename).read({ ref: Octo.branch });
    }

    public async blob(filename: string): Promise<Blob> {
        const contents = await this.repo.contents(filename).fetch();
        contents.content = base64decode(contents.content);
        return contents;
    }

    // Repo

    public async commits(since?: Date): Promise<Array<Commit>> {
        const commitInfo = (since == null)
            ? await this.repo.commits.fetch({ sha: Octo.branch })
            : await this.repo.commits.fetch({ since: since.toISOString(), sha: Octo.branch });

        const commitItems: Array<CommitItem> = commitInfo.items;
        const commits: Array<Commit> = [];
        for (const commit of commitItems) {
            commits.push(commit.commit);
        }
        return commits;
    }

    public async write(writeables: Array<Writeable>): Promise<void> {
        for (const writeable of writeables) {
            await this.repo.contents(writeable.path)
                .add({
                    content: base64encode(writeable.content),
                    message: (writeable.message != null) ? writeable.message : `Updating ${writeable.path}`,
                    sha: writeable.sha,
                });
        }
    }
}

export default Octo;
