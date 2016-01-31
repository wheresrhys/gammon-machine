'use strict';

// 0th and 25th indeces are sinbins
const START_POSITION = [0, 2, 0, 0, 0, 0, -5, 0, -3, 0, 0, 0, 5, -5, 0, 0, 0, 3, 0, 5, 0, 0, 0, 0, -2, 0];
let gameCount = 0;

const Player = require('./player');

// Test to see whether a machine learned strategy is really all that good.
function arrayN (n) {
	return Array(n).join('.').split('.').map(v => undefined);
}

function playGame (conf1, conf2) {
	// console.log('playing game', gameCount++)
	const player1 = new Player(1, START_POSITION.slice(), conf1);

	const player2 = new Player(-1, START_POSITION.slice(), conf2);

	player1.setOpponent(player2);
	player2.setOpponent(player1);
	return player1.randomMove();

}

//
function playTournament (players, rounds) {
  const matrix = [];

	players.forEach((conf1, i) => {
		matrix[i] = [];
		players.forEach((conf2, j) => {
			if (j === i) {
				matrix[i][j] = 0;
			} else if (i > j) {
				matrix[i][j] = -matrix[j][i];
			} else {
				matrix[i][j] = arrayN(rounds).reduce(tot => tot + playGame(conf1, conf2), 0);
			}
		})
	});


	return players.map((player, i) => {
		return {
			player,
			score: matrix[i].reduce((tot, v) => tot + v, 0)
		}
	})
		.sort((o1, o2) => {
			return o1.score > o2.score ? -1 : o1.score < o2.score ? 1 : 0;
		})
};

function playChallengers(champion, players, rounds) {
	const results = players.map((player, i) => {
		return {
			player,
			score: arrayN(rounds)
				.map(() => playGame(champion, player))
				.filter(score => score > 0)
				.length
		}
	})
		.sort((o1, o2) => {
			return o1.score > o2.score ? -1 : o1.score < o2.score ? 1 : 0;
		})
	return {
		gamesWon: 100 * results.reduce((tot, r) => tot + r.score, 0) / (results.length * rounds),
		strategiesBeaten: 100 * results.filter(s => s.score > rounds / 2).length / results.length
	}
}

module.exports = {playGame, playTournament, playChallengers}
