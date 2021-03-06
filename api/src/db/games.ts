import { Game } from '../lib/types';
import Table, { ListArguments } from './table';
import { apiURL } from '../common/utils';

class Games extends Table<Game> {
    public static getInstance(): Games {
        if (Games.instance == null) {
            Games.instance = new Games();
        }

        return Games.instance;
    }

    private static instance: Games | undefined;

    private constructor() {
        super('games');
    }

    public isNameTaken(name: string): boolean {
        for (const game of this.all({first: -1, offset: 0})) {
            if (game.name === name) {
                return true;
            }
        }

        return false;
    }

    public findByIdWithImage(id: number): Game | undefined {
        const game = this.findById(id);
        return game ? this.addImage(game) : undefined;
    }

    public allWithImages(args: ListArguments<Game>): Array<Game> {
        return this.all(args).map(game => this.addImage(game));
    }

    public allByIdsWithImages(ids: readonly number[]): Array<Game> {
        return this.allByIds(ids).map(game => this.addImage(game));
    }

    private addImage(game: Game): Game {
        return {
            ...game,
            image: `${apiURL(true)}/img/games/${game.name}.png`,
        };
    }
}

export default Games;
