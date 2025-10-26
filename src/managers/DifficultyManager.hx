package managers;

import items.Platform;
import spawn.Boost;
import spawn.Fly;

/**
DifficultyManager class handles the game's difficulty progression.
It increases the difficulty based on the player's progress and adjusts item weights accordingly.

@version 1.0
@date 2023-10-01
@author Marko Cettina
**/
class DifficultyManager {
	static inline final HEIGHT_DIVIDER:Float = 10;
	static inline final DIFFICULTY_MULTIPLIER:Float = 10;

	var difficultyThreshold:Float;
	var height:Float;

	public function new() {
		difficultyThreshold = 100;
		height = 0.0;
	}

	/**
	Increases the height of the game based on the horizontal change.
	If the height exceeds the difficulty threshold, it increases the difficulty.
	
	@param horizontalChange The change in horizontal position.
	@throws Error if horizontalChange is negative.
	@return Float
	**/
	public function increaseHeight(horizontalChange:Float):Float {
		height += horizontalChange / HEIGHT_DIVIDER;

		if (height > difficultyThreshold) {
			increaseDifficulty();
		}

		return height;
	}

	function increaseDifficulty() {
		difficultyThreshold *= DIFFICULTY_MULTIPLIER;

		// This is a hacky way to increase the difficulty.		
		// It should be done in a more structured way.
		// But for such a small game, this is sufficient.
		Platform.MovableWeight++;
		Platform.BreakableWeight++;
		Fly.Weight++;
		Boost.Weight++;
	}
}