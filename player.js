'use strict';

function arrayN (n) {
	return Array(n).join('.').split('.').map(v => undefined);
}

const binomialDist = (function () {
	const obj = {};
	for (let i = 1, il = 6; i<=il; i++) {
		for (let j = 1, jl = 6; j<=jl; j++) {
			obj[j + i] = (obj[j + i] || 0) + 1;
		}
	}
	return [undefined, undefined].concat(Object.keys(obj)
		.map(k => {
			return {i: Number(k), v: obj[k]}
		})
		.sort((o1, o2) => o1.i > o2.i ? -1 : 1)
		.map(o =>  o.v / 36));

}())


function getOpenSquares (board) {
	const places = board.reduce((arr, v, i) => {
		if (v > -2 && (!board[0] || i < 7) && i !== 25) {
			arr.push(i);
		}
		return arr;
	}, []);

	if (!board.slice(0, 18).some(p => p > 0)) {
		places.push(-1);
	}
	return places;
}

function getOccupiedSquares (board) {
	if (board[0]) {
		return [0];
	}
	return board.reduce((arr, v, i) => {
		if (v > 0) {
			arr.push(i);
		}
		return arr;
	}, []);
}

function getEnemyBlockedSquares (board) {
	return board.reduce((arr, v, i) => {
		if (v < -1) {
			arr.push(i);
		}
		return arr;
	}, []);
}

function getEnemyVulnerableSquares (board) {
	return board.reduce((arr, v, i) => {
		if (i < 25 && v === 1) {
			arr.push(i);
		}
		return arr;
	}, []);
}

function getMutuallyOpenSquares (board) {
	return board.reduce((arr, v, i) => {
		if (i> 0 && i < 25 && (v === 0 || v === -1)) {
			arr.push(i);
		}
		return arr;
	}, []);
}

function move (roll, board) {
	const boards = [];
	const pieces = getOccupiedSquares(board);
	const targets = getOpenSquares(board);

	pieces.forEach(piece => {
		targets.forEach(target => {
			if (target === -1) {
				if (25 - piece === 0) {
					newBoard[piece]--;
				}
			} else if (target - piece === roll) {
				const newBoard = board.slice();
				newBoard[piece]--;
				if (newBoard[target] > -1) {
					newBoard[target]++;
				} else {
					newBoard[25]--;
					newBoard[target] = 1;
				}
				boards.push(newBoard)
			}
		})
	})

	// handle non exact movees in the endgame
	if (boards.length === 0 && targets.indexOf(-1) > -1) {
		const newBoard = board.slice();
		newBoard[pieces[0]]--;
		boards.push(newBoard);
	}

	return boards;
}

class Player {
	constructor (name, board, conf) {
		this.name = name;
		this.board = board;
		this.conf = conf;
	}

	finished () {
		return !this.board.slice(1).some(v => v > 0);
	}

	overToOpponent (board) {
		this.opponent.setBoard(board.slice().reverse().map(v => 0 - v));
		return this.opponent.randomMove();
	}

	setBoard (board) {
		this.board = board;
	}

	_move(rolls) {
		let boards = [this.board];

		while (rolls.length) {
			const roll = rolls.shift();
			boards = boards.reduce((arr, board) => {
				return arr.concat(move(roll, board))
			}, []);
		}
		return boards;
	}

	scoreBoard (board) {
		const vulnerability = board.reduce((tot, pieces, i) => {
			if (pieces === 1) {
				tot += this.conf.riskAversion * i;
				if (i > 18) {
					tot += this.conf.extremeRiskAversion * i;
				}
			}
			return tot;
		}, 0);

		const strength = board.reduce((tot, pieces, i) => {
			if (pieces > 1) {
				tot += this.conf.strengthPreference * i;
				if (i > 17) {
					tot += this.conf.extremeStrengthPreference * i;
				}
			}
			return tot;
		}, 0);

		const straggler = this.conf.stragglerAversion * arrayN(5).reduce((tot, v, i) => {
			const pieces = board[i];
			if (pieces > 0) {
				return tot + pieces
			}
			return tot;
		}, 0);

		const tactical = this.conf.attackMiddlePreference * [3,4,5,6,7].reduce((tot, v, i) => {
			const pieces = board[i];
			if (pieces > 0) {
				return tot + pieces
			}
			return tot;
		}, 0);

		const aggression = -board[25] * this.conf.killPreference;

		const blocked = getEnemyBlockedSquares(board);

		const targets = getEnemyVulnerableSquares(board);

		const available = getMutuallyOpenSquares(board);

		const coverage = board.reduce((tot, pieces, i) => {
			// can move without vulnerability
			if (pieces === 1 || pieces === 3) {

				for (let j = 2, jl = 12; j <= jl; j++) {
					if (i + j > 24) return;
					if (blocked.indexOf(i + j) > -1) {
						tot -= this.conf.blockedAversion * binomialDist[j];
					}
					// const newVulnerable = pieces === 3 ? 1 : 0;
					if (targets.indexOf(i + j) > -1) {
						tot += this.conf.attackingPreference * binomialDist[j] ;
					}
					if (available.indexOf(i + j) > -1) {
						tot += this.conf.mobilePreference * binomialDist[j];
					}
				}
			}
			return tot;
		})

		return strength + tactical + aggression + coverage - (vulnerability + straggler);
	}

	move (roll1, roll2) {
		let possibleBoards;
		if (roll1 === roll2) {
			possibleBoards = this._move([roll1, roll1, roll1, roll1]);
		} else {
			possibleBoards = this._move([roll1, roll2]).concat(this._move([roll2, roll1]))
		}

		possibleBoards = Object.keys(possibleBoards.reduce((obj, val) => {
			obj[val.join(',')] = true;
			return obj;
		}, {}))
			.map(key => {
				const board = key.split(',').map(n => Number(n))
				return {
					board,
					score: this.scoreBoard(board)
				}
			})
			.sort((b1, b2) => {
				return b1.score > b2.score ? -1 : b1.score < b2.score ? 1 : 0;
			});

		if (possibleBoards.length) {
			this.board = possibleBoards[0].board
		}
		if (this.finished()) {
			return this.name;
		}

		return this.overToOpponent(this.board);
	}

	setOpponent (player) {
		this.opponent = player;
	}

	randomMove () {
		return this.move(Math.ceil(Math.random() * 6), Math.ceil(Math.random() * 6));
	}
}

module.exports = Player;