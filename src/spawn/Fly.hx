package spawn;

import flash.events.Event;

/**
	Fly class represents a spawn item that moves in a sine wave pattern.
	It can be used to create dynamic gameplay elements that challenge the hero.

	@version 1.0
	@date 2023-10-01
	@author Marko Cettina
**/
class Fly extends SpawnItem {
	/**
		The height of the Fly item.
	**/
	public static inline var HEIGHT:Int = 50;

	/**
		The width of the Fly item.
	**/
	public static inline var WIDTH:Int = 25;

	static inline final ELIPSE_RADIUS:Int = 5;
	static inline final WAVE_HEIGHT:Int = 5;
	static inline final WAVE_LENGTH:Int = 10;

	static inline final COLOR:UInt = 0xFF3800;

	/**
		Time necessary to pass for respawn
	**/
	static inline final TIME_OUT:Float = 100.0;

	/**
		Respawn time counter
	**/
	static var TimeOutCounter:Float = 10.0;

	/**
		Direction of the Fly's movement.
		It can be either -1 (left) or 1 (right).
	**/
	var direction:Int;

	/**
		Weight of the item, used for difficulty scaling.
		This is a static value that can be adjusted based on game design.
	**/
	public static var Weight(default, default):Float = 0.0;

	public function new() {
		super();

		this.graphics.beginFill(COLOR);
		this.graphics.drawRoundRect(0, 0, HEIGHT, WIDTH, ELIPSE_RADIUS, ELIPSE_RADIUS);
		this.graphics.endFill();
	}

	/**
		Returns the weight of the Fly item.
		This is used to determine the probability of this item being spawned.
		The weight can be adjusted based on game difficulty or other factors.

		@return Float The weight of the Fly item.
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
		Resets the timeout counter for the Fly item.
		This is used to prepare the item for respawning after it has been used.
	**/
	public function resetTimeOutCounter():Void {
		TimeOutCounter = TIME_OUT;
	}

	override public function addedToStage(event:Event) {
		super.addedToStage(event);

		direction = Math.random() > 0.5 ? -1 : 1;
		this.x = direction < 0 ? stage.stageWidth : 0;
		this.y = Math.random() * (stage.stageHeight >> 2);
	}

	override public function update(deltaTime:Float) {
		sineWaveMove(direction, WAVE_HEIGHT, WAVE_LENGTH, this.y);
	}

	/**
		Moves the Fly in a sine wave pattern.
		This method updates the position of the Fly based on a sine wave function,
		creating a smooth oscillating movement.

		@param speed The speed of the Fly's horizontal movement.
		@param waveHeight The height of the sine wave.
		@param waveLength The length of one complete sine wave cycle.
		@param yStartPosition The starting vertical position for the sine wave.
	**/
	function sineWaveMove(speed:Int, waveHeight:Int, waveLength:Int, yStartPosition:Float) {
		this.x += speed;
		this.y = (waveHeight * Math.sin(this.x / waveLength)) + yStartPosition;
	}
}