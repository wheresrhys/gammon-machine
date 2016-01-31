'use strict'
const Player = require('./player');
// 0th and 25th indeces are sinbins
const START_POSITION = [0, 2, 0, 0, 0, 0, -5, 0, -3, 0, 0, 0, 5, -5, 0, 0, 0, 3, 0, 5, 0, 0, 0, 0, -2, 0];

const player1 = new Player('player1', START_POSITION.slice(), {
	pipAverseness: 3,
	sinbinAverseness: 3,
	riskAverseness: 3,
	extremeRiskAverseness: 3,
	strengthPreference: 3,
	extremeStrengthPreference: 3
});


const player2 = new Player('player2', START_POSITION.slice(), {
	pipAverseness: 3,
	sinbinAverseness: 0,
	riskAverseness: 0,
	extremeRiskAverseness: 0,
	strengthPreference: 3,
	extremeStrengthPreference: 3
});

player1.setOpponent(player2);
player2.setOpponent(player1);
player1.randomMove();


