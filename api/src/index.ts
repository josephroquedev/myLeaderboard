import './env';

import express, { ErrorRequestHandler, RequestHandler } from 'express';
import Octo from './common/Octo';

// Print out startup time to default logs
console.log('--------------------');
console.log('Starting new instance of server.');
console.log(new Date());
console.log('--------------------');

// Print out startup time to error
console.error('--------------------');
console.error('Starting new instance of server.');
console.error(new Date());
console.error('--------------------');

const githubToken = process.env.GITHUB_TOKEN;
if (githubToken != null && githubToken.length > 0) {
    Octo.setToken(githubToken);
}

const app = express();
const port = 3001;

app.use((_, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
    next();
});

app.use(express.json());

// Log each request made to the server
app.use((req, _, next) => {
    console.log(`${new Date().toISOString()}: ${req.method} from ${req.ip} -- ${req.originalUrl}`);
    next();
});

const errorHandler: ErrorRequestHandler = (err, _, res, __): void => {
    console.log(err);
    res.json(err);
};

const tokenExtraction: RequestHandler = (req, _, next): void => {
    const token = req.body.token;
    if (token != null && token.length > 0) {
        Octo.setToken(req.body.token);
    }

    next();
};

import applyBoardsRouter from './boards/router';
import applyGamesRouter from './games/router';
import applyMiscRouter from './misc/router';
import applyPlayersRouter from './players/router';
import applyPlaysRouter from './plays/router';
import applyGraphQLRouter from './graphql/router';

app.use(express.static('./static'));
app.use(tokenExtraction);
applyBoardsRouter(app);
applyGamesRouter(app);
applyPlayersRouter(app);
applyPlaysRouter(app);
applyMiscRouter(app);
applyGraphQLRouter(app);
app.use(errorHandler);

// SSL

import fs from 'fs';
import https from 'https';
import { apiURL } from './common/utils';

if (process.env.SSL_ENABLED) {
    const privateKey = fs.readFileSync(`/etc/letsencrypt/live/${apiURL(false)}/privkey.pem`, 'utf8');
    const certificate = fs.readFileSync(`/etc/letsencrypt/live/${apiURL(false)}/cert.pem`, 'utf8');
    const ca = fs.readFileSync(`/etc/letsencrypt/live/${apiURL(false)}/chain.pem`, 'utf8');

    const credentials = {
        ca,
        cert: certificate,
        key: privateKey,
    };

    const httpsServer = https.createServer(credentials, app);
    httpsServer.listen(443, () => {
        console.log('myLeaderboard API listening on port 443.');
    });
} else {
    app.listen(port, () => {
        console.log(`myLeaderboard API listening on port ${port}`);
        console.log(`http://localhost:${port}`);
    });
}

import Boards from './db/boards';
import Games from './db/games';
import Players from './db/players';
import Plays from './db/plays';

Boards.getInstance().refreshData();
Games.getInstance().refreshData();
Players.getInstance().refreshData();
Plays.getInstance().refreshData();
