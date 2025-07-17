package spawn;

/**
	SpawnItem class represents an item that can be spawned in the game.

	@version 1.0
	@date 2023-10-01
	@author Marko Cettina
**/
class Boost extends SpawnItem {
	/**
		Height of the Boost item.
		This is a static value that can be adjusted based on game design.
	**/
	public static inline final HEIGHT:UInt = 20;

	/**
		Width of the Boost item.
		This is a static value that can be adjusted based on game design.
	**/
	public static inline final WIDTH:UInt = 25;

	static inline final COLOR:UInt = 0x0000FF;

	/**
		Time necessary to pass for respawn
	**/
	static inline final TIME_OUT:Float = 100.0;

	/**
		Respawn time counter
	**/
	static var TimeOutCounter:Float = 10.0;

	/**
		Weight of the item, used for difficulty scaling.
		This is a static value that can be adjusted based on game design.
	**/
	public static var Weight(default, default):Float = 0;

	public function new() {
		super();

		this.graphics.beginFill(COLOR);
		this.graphics.drawRect(0, 0, WIDTH, HEIGHT);
		this.graphics.endFill();
	}

	/**
		Returns the weight of the Boost item.
		This is used to determine the probability of this item being spawned.
		The weight can be adjusted based on game difficulty or other factors.

		@return Float The weight of the Boost item.
	**/
	public function getSpawnWeight():Float {
		return Weight;
	}

	/**
		Updates the timeout counter for the Fly item.
		This method decreases the timeout counter if the item is not live.
		If the item is live, the counter remains unchanged.

		@param elapsed The time elapsed since the last update.
	**/
	public function updateTimeOut(elapsed:Float) {
		if (!live) {
			TimeOutCounter = TimeOutCounter > 0 ? TimeOutCounter - elapsed : 0;
		}
	}

	/**
		Returns the time remaining before the item can be respawned.
		This is used to check if the item is ready to be spawned again.

		@return Float The time remaining before respawn.
	**/
	public function getTimeOutCounter():Float {
		return TimeOutCounter;
	}

	/**
		Resets the timeout counter for the Boost item.
		This is used to prepare the item for respawning after it has been used.
	**/
	public function resetTimeOutCounter():Void {
		TimeOutCounter = TIME_OUT;
	}
}