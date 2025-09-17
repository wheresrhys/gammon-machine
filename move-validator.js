const START_POSITION = [0, 2, 0, 0, 0, 0, -5, 0, -3, 0, 0, 0, 5, -5, 0, 0, 0, 3, 0, 5, 0, 0, 0, 0, -2, 0];
const START_MOVES = [...Array(60)].map(x => Math.random());


Hmmm... can I redo this so that it just picks a square and tries to move it, be it valid or not??
Woudl prob be simpler

function invertBoard (board){
	return  [...board].reverse().map(val => -1 * val)
}

function orderPiecePreferenceForMove (probabilities) {
	return probabilities
		.map((prob, piece) => ({prob, piece}))
		.sort(({prob: prob1}, {prob: prob2}) => {
			if (prob1 === prob2) return 0
			return prob1 > prob2 ? -1 : 1;
		})
}

function structureMoves (moves) {
	return [
		orderPiecePreferenceForMove(moves.slice(0, 15)),
		orderPiecePreferenceForMove(moves.slice(15, 30)),
		orderPiecePreferenceForMove(moves.slice(30, 45)),
		orderPiecePreferenceForMove(moves.slice(45, 60))
	]
}


function getOrderedPieces (board) {
	const pieces = []

	board.forEach((square, i) => {
		while (square > 0) {
			pieces.push(i)
			square--
		}
	})
	return pieces
}

function validateMove (startPosition, board, roll) {
	const endPosition = startPosition + roll
	if (endPosition < 25) {
		if (board[endPosition] < -1) return false;
	} else {
		// double check that this actually tests that everything is in the end zone.
		if (!board.slice(0, 17).every(val => val < 1)) return false;

		if (endPosition > 25) {
			return !board.every((val, i) => {
				if (val > 0) {
					return i + roll > 25
				}
			})
		}
	}
	return true;
}

function movePiece (move, board, orderedPieces, roll) {
	if (roll === 0) return undefined
	// consider what to do when no valid moves
	while (move.length) {
		const pieceToMove = move.shift().piece;
		const startPosition = orderedPieces[pieceToMove]
		if (startPosition === -1) {
			// the piece has already left the building
			continue;
		}
		const isValid  = validateMove(startPosition, board, roll);
		if (isValid) {
			const endPosition = startPosition + roll
			if (endPosition > 24) {
				orderedPieces[pieceToMove] = -1;
			} else {
				orderedPieces[pieceToMove] = endPosition;
			}
			board[startPosition] = board[startPosition] - 1;
			if (endPosition < 25) {
				if (board[endPosition] === -1) {
					board[endPosition] = 1;
					board[25] = board[25] -1;
				} else {
					board[endPosition] = board[endPosition] + 1;
				}
			}

			return 15 - move.length
		}
		return -1

	}
}

function takeTurn ({player, board, rolls, moves}) {
	if (player === -1) {
		board = invertBoard(board)
	}

	const orderedPieces = getOrderedPieces(board);
	const structuredMoves = structureMoves(moves);
	const movesMade = structuredMoves.map((move, i) => movePiece(
		move, board, orderedPieces, rolls[i]
	))
	return {
		movesMade,
		board,
		isGameOver: board.every(val => val < 1),
		invalidMovesCount: movesMade.filter(val => val === -1).length
	};

}


console.log(takeTurn({
	board: START_POSITION,
	moves: START_MOVES,
	player: 1,
	rolls: [2, 3, 0, 0]
}))

