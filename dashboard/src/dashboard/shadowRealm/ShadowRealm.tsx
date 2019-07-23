import { Page } from '@shopify/polaris';
import React from 'react';
import PlayerView from '../../components/PlayerView';
import { GameStandings, Player, PlayerRecord } from '../../lib/types';
import './ShadowRealm.css';

interface Props {
    players: Array<Player>;
    standings: GameStandings;
}

interface State {
    banished: Array<Player>;
}

class ShadowRealm extends React.Component<Props, State> {
    constructor(props: Props) {
        super(props);
        this.state = {
            banished: [],
        };
    }

    public componentDidMount() {
        this._identifyBanishedPlayers();
    }

    public componentDidUpdate(prevProps: Props) {
        if (this.props.players !== prevProps.players) {
            this._identifyBanishedPlayers();
        }
    }

    public render() {
        const { banished } = this.state;
        if (banished.length === 0) {
            return null;
        }

        return (
            <Page title={'Shadow Realm'}>
                <div className={'shadowRealm'}>
                    {this.state.banished.map(player => <PlayerView key={player.username} player={player} banished={true} />)}
                </div>
            </Page>
        );
    }

    private _identifyBanishedPlayers() {
        const { players, standings } = this.props;
        const banished = players.filter(player => {
            const playerRecord = standings[player.id];
            return playerRecord == null ? false : isBanished(playerRecord);
        });
        this.setState({ banished });
    }
}

export function freshness(record: PlayerRecord): number {
    const today = new Date();
    const seconds = (today.getTime() - new Date(record.lastPlayed).getTime()) / 1000;
    const daysSinceLastPlayed = Math.floor(seconds / 86400);

    if (daysSinceLastPlayed < 7) {
        // Played in the last week? Very fresh.
        return 1;
    } else if (daysSinceLastPlayed > 30) {
        // Haven't played in a month? Stale.
        return 0;
    } else {
        // Otherwise, freshness is 0-1, based on number of days
        return Math.min((23 - (daysSinceLastPlayed - 7)) / 23, 1);

    }
}

export function isBanished(player: PlayerRecord): boolean {
    return freshness(player) === 0;
}

export default ShadowRealm;
