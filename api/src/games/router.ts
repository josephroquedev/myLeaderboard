import express, { Express } from 'express';
import listGames from './list';
import newGame from './new';
import gameStandings from './standings';

const router = express.Router();

router.post('/new', (req, res, next) => {
    newGame(req).then(game => {
        res.json(game);
    }).catch(error => {
        next(error);
    });
});

router.get('/list', (_, res, next) => {
    listGames().then(games => {
        res.json(games);
    }).catch(error => {
        next(error);
    });
});

router.get('/standings/:id', (req, res, next) => {
    gameStandings(req).then(standings => {
        res.json(standings);
    }).catch(error => {
        next(error);
    });
});

export default function applyRouter(app: Express) {
    app.use('/games', router);
}
