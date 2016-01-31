'use strict';

const compete = require('./compete');

function arrayN (n) {
	return Array(n).join('.').split('.').map(v => undefined);
}

const players = 10;
const sample = 10;

const confNames = [
	'stragglerAversion',
	'riskAversion',
	'extremeRiskAversion',
	'strengthPreference',
	'extremeStrengthPreference'
];

function getWinners(players) {
	return compete.playTournament(players, sample)
		.slice(0, 2)
		.map(c => c.player)

}

function procreate (player1, player2) {
	return arrayN(players - 2).map(() => {
		return confNames.reduce((obj, name) => {
			const random = Math.random();
			obj[name] = Math.random() * player1[name] + Math.random() * player2[name];
			return obj;
		}, {})
	// always include the parents too
	}).concat([player1, player2]);
}

function evolve (parents, generations) {
	let incrementer = generations;
	let thoroughbreds = parents;
	let foals;
	while (incrementer--) {
		console.log('new generation', generations - incrementer)
		foals = procreate(thoroughbreds[0], thoroughbreds[1]);
		thoroughbreds = getWinners(foals);
		const success = compete.playChallengers(thoroughbreds[0], randomPlayers(50), 7);
		console.log(`percentage games won in generation ${generations - incrementer}: ${success.gamesWon}`);
		console.log(`percentage strategies beaten in generation ${generations - incrementer}: ${success.strategiesBeaten}`);
	}

	return thoroughbreds[0];
}

function randomPlayers(n) {
	return arrayN(n)
		.map(v => {
			return confNames.reduce((obj, name) => {
				obj[name] = Math.random();
				return obj;
			}, {})
		})
}

const stallion = evolve(randomPlayers(2), 20);

console.log('stallion', stallion)


