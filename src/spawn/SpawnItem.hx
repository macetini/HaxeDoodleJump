package spawn;

import items.GameItem;

/**
	SpawnItem class represents an item that can be spawned in the game.
	It is a base class for items like Boost and Fly, which have specific behaviors and properties.

	@version 1.0
	@date 2023-10-01
	@author Marko Cettina
**/
abstract class SpawnItem extends GameItem {
	/**
		Indicates if the spawn item is currently active.
		If true, the item is visible and can interact with the hero.
	**/
	public var live(default, default):Bool;

	public function new() {
		super();
	}

	/**	 
		Returns the weight of the spawn item.
		This is used to determine the probability of this item being spawned.
		The weight can be adjusted based on game difficulty or other factors.

		@return Float The weight of the spawn item.
	**/
	public abstract function getSpawnWeight():Float;

	/**
		Updates the timeout for the spawn item.
		This method should be called every frame to manage the respawn timing.

		@param elapsed The time elapsed since the last frame.
	**/
	public abstract function updateTimeOut(elapsed:Float):Void;

	/**
		Returns the time remaining before the item can be respawned.
		This is used to check if the item is ready to be spawned again.

		@return Float The time remaining before respawn.
	**/
	public abstract function getTimeOutCounter():Float;

	/**
		Resets the timeout counter for the spawn item.
		This is used to prepare the item for respawning after it has been used.
	**/
	public abstract function resetTimeOutCounter():Void;

	override public function recycleFinished() {
		live = false;
		super.recycleFinished();
	}
}