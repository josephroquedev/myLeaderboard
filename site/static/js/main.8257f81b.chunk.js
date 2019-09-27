(window["webpackJsonpmy-leaderboard"]=window["webpackJsonpmy-leaderboard"]||[]).push([[0],{226:function(e,t,n){},227:function(e,t,n){},228:function(e,t,n){},229:function(e,t,n){},230:function(e,t,n){},231:function(e,t,n){},232:function(e,t,n){"use strict";n.r(t);var r=n(7),a=n(0),s=n.n(a),i=n(29),c=n.n(i),o=n(5),u=n.n(o),l=n(20),h=n(14),f=n(11),d=n(18),p=n(17),m=n(19),v=function(){function e(){Object(h.a)(this,e)}return Object(f.a)(e,null,[{key:"getInstance",value:function(){return null==e.instance&&(e.instance=new e),e.instance}}]),Object(f.a)(e,[{key:"games",value:function(){var t=Object(l.a)(u.a.mark((function t(){var n,r;return u.a.wrap((function(t){for(;;)switch(t.prev=t.next){case 0:return t.next=2,fetch("".concat(e.baseURL,"/games/list"));case 2:return n=t.sent,t.next=5,n.json();case 5:return r=t.sent,t.abrupt("return",r);case 7:case"end":return t.stop()}}),t)})));return function(){return t.apply(this,arguments)}}()},{key:"players",value:function(){var t=Object(l.a)(u.a.mark((function t(){var n,r;return u.a.wrap((function(t){for(;;)switch(t.prev=t.next){case 0:return t.next=2,fetch("".concat(e.baseURL,"/players/list?includeAvatars=true"));case 2:return n=t.sent,t.next=5,n.json();case 5:return r=t.sent,t.abrupt("return",r);case 7:case"end":return t.stop()}}),t)})));return function(){return t.apply(this,arguments)}}()},{key:"gameStandings",value:function(){var t=Object(l.a)(u.a.mark((function t(n){var r,a;return u.a.wrap((function(t){for(;;)switch(t.prev=t.next){case 0:return t.next=2,fetch("".concat(e.baseURL,"/games/standings/").concat(n));case 2:return r=t.sent,t.next=5,r.json();case 5:return a=t.sent,t.abrupt("return",a);case 7:case"end":return t.stop()}}),t)})));return function(e){return t.apply(this,arguments)}}()},{key:"hasUpdates",value:function(){var t=Object(l.a)(u.a.mark((function t(n){var r,a;return u.a.wrap((function(t){for(;;)switch(t.prev=t.next){case 0:return t.next=2,fetch("".concat(e.baseURL,"/misc/hasUpdates?since=").concat(n.toISOString()));case 2:return r=t.sent,t.next=5,r.json();case 5:return a=t.sent,t.abrupt("return",a.hasUpdates);case 7:case"end":return t.stop()}}),t)})));return function(e){return t.apply(this,arguments)}}()}]),e}();v.instance=void 0,v.baseURL="https://myleaderboard.josephroque.dev";var y=v,b=function(e){function t(e){var n;return Object(h.a)(this,t),(n=Object(d.a)(this,Object(p.a)(t).call(this,e))).refreshInterval=void 0,n.startTime=void 0,n.startTime=new Date,n.state={errorMessage:void 0},n}return Object(m.a)(t,e),Object(f.a)(t,[{key:"componentDidMount",value:function(){this._startRefreshLoop()}},{key:"render",value:function(){var e=this,t=this.state.errorMessage;return null==t?null:s.a.createElement(r.e,{title:""},s.a.createElement(r.c,null,s.a.createElement(r.b,{title:"Failed to refresh",onDismiss:function(){return e._startRefreshLoop()},status:"critical"},s.a.createElement("p",null,t))))}},{key:"_startRefreshLoop",value:function(){var e=this;null!=this.state.errorMessage&&this.setState({errorMessage:void 0}),null!=this.refreshInterval&&window.clearInterval(this.refreshInterval),this.refreshInterval=window.setInterval((function(){return e._refreshLoop()}),this.props.refreshTime)}},{key:"_refreshLoop",value:function(){var e=Object(l.a)(u.a.mark((function e(){return u.a.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return e.prev=0,e.next=3,y.getInstance().hasUpdates(this.startTime);case 3:e.sent&&window.location.reload(),e.next=10;break;case 7:e.prev=7,e.t0=e.catch(0),this.setState({errorMessage:"".concat(e.t0)});case 10:case"end":return e.stop()}}),e,this,[[0,7]])})));return function(){return e.apply(this,arguments)}}()}]),t}(s.a.Component);n(226);function g(e){var t=((new Date).getTime()-new Date(e.lastPlayed).getTime())/1e3,n=Math.floor(t/86400);if(n<=7)return 1;if(n>=21)return 0;return Math.max(0,Math.min((14-(n-7))/14,1))}function w(e){return 0===g(e)}n(227);var j=function(e){var t,n=e.player,r=e.record,a=e.banished,i=e.limbo;return t=a||i?1:null!=r?g(r):1,s.a.createElement("img",{src:n.avatar,alt:n.displayName,className:"avatar",style:{opacity:t}})},k=(n(228),function(e){function t(e){var n;return Object(h.a)(this,t),(n=Object(d.a)(this,Object(p.a)(t).call(this,e))).state={limboing:[]},n}return Object(m.a)(t,e),Object(f.a)(t,[{key:"componentDidMount",value:function(){var e=this.props,t=e.players,n=e.standings,r=t.filter((function(e){var t=n.records[e.id];if(null==t)return!1;var r=g(t);return r>0&&r<.2}));this.setState({limboing:r})}},{key:"render",value:function(){return 0===this.state.limboing.length?null:s.a.createElement(r.e,{title:"Limbo"},s.a.createElement("div",{className:"limbo"},this.state.limboing.map((function(e){return s.a.createElement(j,{key:e.username,player:e,limbo:!0})}))))}}]),t}(s.a.Component)),O=(n(229),function(e){function t(e){var n;return Object(h.a)(this,t),(n=Object(d.a)(this,Object(p.a)(t).call(this,e))).state={banished:[]},n}return Object(m.a)(t,e),Object(f.a)(t,[{key:"componentDidMount",value:function(){this._identifyBanishedPlayers()}},{key:"componentDidUpdate",value:function(e){this.props.players!==e.players&&this._identifyBanishedPlayers()}},{key:"render",value:function(){return 0===this.state.banished.length?null:s.a.createElement(r.e,{title:"Shadow Realm"},s.a.createElement("div",{className:"shadowRealm"},this.state.banished.map((function(e){return s.a.createElement(j,{key:e.username,player:e,banished:!0})}))))}},{key:"_identifyBanishedPlayers",value:function(){var e=this.props,t=e.players,n=e.standings,r=t.filter((function(e){var t=n.records[e.id];return null!=t&&w(t)}));this.setState({banished:r})}}]),t}(s.a.Component)),E=n(56),_=5,x=0,S=3;var R=function(){return s.a.createElement("p",null,"v".concat(_,".").concat(x,".").concat(S))},I=(n(230),function(e){function t(e){var n;return Object(h.a)(this,t),(n=Object(d.a)(this,Object(p.a)(t).call(this,e))).state={banishedPlayers:new Set},n}return Object(m.a)(t,e),Object(f.a)(t,[{key:"componentDidMount",value:function(){this._parseStandings()}},{key:"componentDidUpdate",value:function(e){this.props.standings!==e.standings&&this._parseStandings()}},{key:"render",value:function(){var e=this,t=this.props,n=t.game,a=t.players,i=t.standings,c=a.filter((function(t){return!1===e.state.banishedPlayers.has(t.id)}));return s.a.createElement(r.e,{title:n.name},s.a.createElement(r.c,null,s.a.createElement(r.d,{columnContentTypes:c.map((function(e){return"text"})),headings:[],rows:[[s.a.createElement(R,null),"Total"].concat(Object(E.a)(c.map((function(e){return s.a.createElement(j,{player:e,record:i.records[e.id]})}))))].concat(Object(E.a)(c.map((function(t){var n=[],r=!0,a=!1,o=void 0;try{for(var u,l=c[Symbol.iterator]();!(r=(u=l.next()).done);r=!0){var h=u.value;if(h.username!==t.username){var f=i.records[t.id].records[h.id];null!=f?n.push(e._formatRecord(f,!1)):n.push(e._formatRecord({wins:0,losses:0,ties:0},!1))}else n.push("\u2014")}}catch(d){a=!0,o=d}finally{try{r||null==l.return||l.return()}finally{if(a)throw o}}return[s.a.createElement(j,{key:t.username,player:t,record:i.records[t.id]}),e._formatRecord(i.records[t.id].overallRecord,!0)].concat(n)}))))})))}},{key:"_parseStandings",value:function(){var e=this.props,t=e.players,n=e.standings,r=this._identifyBanishedPlayers(n,t);this.setState({banishedPlayers:r})}},{key:"_identifyBanishedPlayers",value:function(e,t){return new Set(t.filter((function(t){return w(e.records[t.id])})).map((function(e){return e.id})))}},{key:"_formatRecord",value:function(e,t){var n=["record"];return t&&n.push("record--overall"),e.isWorst&&n.push("record--worst"),e.isBest&&n.push("record--best"),s.a.createElement("div",{className:n.join(" ")},s.a.createElement("span",{className:"record--value record--wins"},e.wins),"-",s.a.createElement("span",{className:"record--value record--losses"},e.losses),e.ties>0?s.a.createElement("span",null,"-",s.a.createElement("span",{className:"record--value record--ties"},e.ties)):null)}}]),t}(s.a.Component)),L=function(e){function t(e){var n;return Object(h.a)(this,t),(n=Object(d.a)(this,Object(p.a)(t).call(this,e))).refreshInterval=void 0,n.state={banishedPlayers:new Set,playersWithGames:[],refresh:!1,standings:void 0},n}return Object(m.a)(t,e),Object(f.a)(t,[{key:"componentDidMount",value:function(){this._fetchStandings(),this._startRefreshLoop()}},{key:"render",value:function(){var e=this,t=this.state,n=t.refresh,a=t.standings,i=t.playersWithGames,c=this.props.game;if(null==a||0===i.length)return null;var o=i.filter((function(t){return!1===e.state.banishedPlayers.has(t.id)}));return i.length>0&&0===o.length?s.a.createElement(r.e,{title:c.name},s.a.createElement("h1",{className:"no-recent-plays"},"No recent plays...")):s.a.createElement("div",{className:"game-dashboard"},s.a.createElement(I,{key:c.id,game:c,standings:a,players:i,forceRefresh:n}),s.a.createElement(k,{standings:a,players:i,forceRefresh:n}),s.a.createElement(O,{standings:a,players:i,forceRefresh:n}))}},{key:"_fetchStandings",value:function(){var e=Object(l.a)(u.a.mark((function e(){var t,n,r,a;return u.a.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return t=this.props.players,e.next=3,y.getInstance().gameStandings(this.props.game.id);case 3:n=e.sent,r=t.filter((function(e){var t=n.records[e.id];if(null==t)return!1;var r=t.overallRecord,a=r.wins,s=r.losses,i=r.ties;return a>0||s>0||i>0})),a=this._identifyBanishedPlayers(n,r),this.setState({banishedPlayers:a,playersWithGames:r,standings:n});case 7:case"end":return e.stop()}}),e,this)})));return function(){return e.apply(this,arguments)}}()},{key:"_identifyBanishedPlayers",value:function(e,t){return new Set(t.filter((function(t){return w(e.records[t.id])})).map((function(e){return e.id})))}},{key:"_startRefreshLoop",value:function(){var e=this;null!=this.refreshInterval&&window.clearInterval(this.refreshInterval),this.refreshInterval=window.setInterval((function(){return e._refreshLoop()}),36e5)}},{key:"_refreshLoop",value:function(){var e=Object(l.a)(u.a.mark((function e(){return u.a.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:this.setState({refresh:!this.state.refresh});case 1:case"end":return e.stop()}}),e,this)})));return function(){return e.apply(this,arguments)}}()}]),t}(s.a.Component),D=function(e){function t(e){var n;return Object(h.a)(this,t),(n=Object(d.a)(this,Object(p.a)(t).call(this,e))).state={games:[],players:[]},n}return Object(m.a)(t,e),Object(f.a)(t,[{key:"componentDidMount",value:function(){this._fetchData()}},{key:"render",value:function(){var e=this.state,t=e.games,n=e.players;return s.a.createElement("div",null,s.a.createElement(b,{refreshTime:2e4}),t.map((function(e){return s.a.createElement(L,{key:e.id,game:e,players:n})})))}},{key:"_fetchData",value:function(){var e=Object(l.a)(u.a.mark((function e(){var t,n;return u.a.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return e.next=2,y.getInstance().games();case 2:return t=e.sent,e.next=5,y.getInstance().players();case 5:(n=e.sent).sort((function(e,t){return e.username.toLowerCase().localeCompare(t.username.toLowerCase())})),this.setState({games:t,players:n});case 8:case"end":return e.stop()}}),e,this)})));return function(){return e.apply(this,arguments)}}()}]),t}(s.a.Component);n(231);c.a.render(s.a.createElement(r.a,{i18n:{}},s.a.createElement(D,null)),document.getElementById("root"))},97:function(e,t,n){e.exports=n(232)}},[[97,1,2]]]);
//# sourceMappingURL=main.8257f81b.chunk.js.map