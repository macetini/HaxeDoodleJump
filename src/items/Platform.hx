package items;

import flash.events.Event;

/**
	Platform class represents a platform in the Doodle Jump game.
	It can be normal, breakable, or movable, and handles its own movement and rendering.

	@version 1.0
	@date 2023-10-01
	@author Marko Cettina
**/
class Platform extends GameItem {
	/**
		The height of the platform.
	**/
	public static inline final HEIGHT:Int = 20;

	/**
		The width of the platform.
	**/
	public static inline final WIDTH:Int = 100;

	static inline final NORMAL_COLOR:UInt = 0x00FFFF;
	static inline final BREAKABLE_COLOR:UInt = 0x302013;
	static inline final MOVABLE_COLOR:UInt = 0xFF00FF;

	/**
		Weight values for different types of platforms.
		These weights determine the probability of each type being created.
	**/
	public var normalWeight(default, default):Int = 10;

	/**
		Weight for breakable platforms.
		Breakable platforms can be destroyed by the hero.
	**/
	public static var BreakableWeight(default, default):Int = 0;

	/**
		Weight for movable platforms.
		Movable platforms can move horizontally across the screen.
		This is used to determine the chance of a platform being movable.
	**/
	public static var MovableWeight(default, default):Int = 0;

	/**
		The direction in which the movable platform moves.
		-1 for left, 1 for right.
	**/
	var direction:Int;

	/**
		Indicates if the platform is movable.
		Movable platforms can move horizontally across the screen.
	**/
	var movable:Bool;

	/**
		Indicates if the platform is a normal platform.
		Normal platforms are static and do not break.
	**/
	public var normal(default, null):Bool;

	/**
		Indicates if the platform is breakable.
	**/
	public var breakable(default, null):Bool;

	/**
		Indicates if the there is an boost item on the platform.
		Boost items can provide temporary speed or jump boosts to the hero.
	**/
	public var hasBoost(default, default):Bool;

	public function new() {
		super();

		normalWeight = 10;

		movable = false;
		normal = false;
		breakable = false;
		hasBoost = false;
	}

	override public function removedFromStage(event:Event) {
		super.removedFromStage(event);
		resetPlatform();
	}

	/**
		Resets the platform properties to their default values.
		This is called when the platform is removed from the stage.
	**/
	public function resetPlatform() {
		movable = false;
		normal = false;
		breakable = false;
		hasBoost = false;
		this.graphics.clear();
	}

	override public function addedToStage(event:Event) {
		super.addedToStage(event);
		initPlatform();
	}

	/**
		TODO - REFACTOR - Factory pattern maybe.
	**/
	function initPlatform() {
		direction = Math.random() > 0.5 ? -1 : 1;

		var total:UInt = normalWeight + BreakableWeight + MovableWeight;
		var chance:Float = total * Math.random();

		chance -= normalWeight;

		if (chance <= 0) {
			normal = true;
			drawColor(NORMAL_COLOR);

			return;
		}

		chance -= BreakableWeight;

		if (chance <= 0) {
			breakable = true;
			drawColor(BREAKABLE_COLOR);

			return;
		}

		chance -= MovableWeight;

		if (chance <= 0) {
			movable = true;
			drawColor(MOVABLE_COLOR);
		}
	}

	function drawColor(color:UInt) {
		this.graphics.beginFill(color);
		this.graphics.drawRect(0, 0, WIDTH, HEIGHT);
		this.graphics.endFill();
	}

	override public function update(deltaTime:Float) {
		if (movable) {
			movePlatform(deltaTime);
		}
	}

	function movePlatform(deltaTime:Float) {
		if (this.x + this.width >= stage.stageWidth || this.x <= 0) {
			direction *= -1;
		}
		this.x += direction;
	}
}