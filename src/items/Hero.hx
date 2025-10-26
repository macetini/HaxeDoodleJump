package items;

import flash.events.Event;

/**
	Hero class represents the player character in the Doodle Jump game.
	It handles player input, movement, and jumping mechanics.

	@version 1.0
	@date 2023-10-01
	@author Marko Cettina
**/
class Hero extends GameItem {
	/**
		The radius of the hero character.
		This is used for collision detection and rendering.
	**/
	public static inline final RADIUS:Int = 30;

	static inline final COLOR:UInt = 0x00FF00;
	static inline final JUMP_BORDER:UInt = 150;
	static inline final POWER_JUMP_MULTIPLAYER:UInt = 3;

	var horizontalVelocity:Float;
	var verticalPull:Float;
	var initialJumpPower:Float;
	var currentJumpPower:Float;
	var isJumping:Bool;
	var floor:Int;

	var currentDeltaTime:Float;
	var isSuperJumpPending:Bool;

	var active:Bool;

	/**
		The real Y position of the hero, used for calculations.
		This is different from the display Y position due to the jumping mechanics.
	**/
	public var realY(default, null):Float;

	public function new() {
		super();

		horizontalVelocity = 6;
		verticalPull = 1;
		initialJumpPower = 65;
		currentJumpPower = 0;
		isJumping = false;
		isSuperJumpPending = false;

		active = false;

		this.graphics.beginFill(COLOR);
		this.graphics.drawCircle(RADIUS, RADIUS, RADIUS);
		this.graphics.endFill();
	}

	override public function addedToStage(event:Event) {
		super.addedToStage(event);

		floor = stage.stageHeight;
		realY = this.y;
	}

	override public function update(deltaTime:Float) {
		currentDeltaTime = deltaTime;

		if (realY + this.height + 1 >= floor) {
			die();
		}

		if (isJumping) {
			updateJumpMovement();
		} else if (active) {
			jump();
		}

		checkForThePositionChange();
	}

	/**
		Moves the hero horizontally based on the provided direction.
		@param direction The direction to move in (-1 for left, 1 for right).
	**/
	public function move(direction:Float) {
		if (active) {
			this.x += direction * horizontalVelocity;
		}
	}

	/**
		Activates the hero and starts the jump process.
	**/
	public function activate() {
		if (!active) {
			active = true;
			jump();
		}
	}

	/**
		Starts the jump process. If a super jump is pending, it uses a higher jump power.
		Otherwise, it uses the initial jump power.	
	**/
	public function jump() {
		if (isSuperJumpPending) {
			currentJumpPower = initialJumpPower * POWER_JUMP_MULTIPLAYER;
		} else {
			currentJumpPower = initialJumpPower;
		}

		isSuperJumpPending = false;
		isJumping = true;

		realY = this.y;

		updateJumpMovement();
	}

	function updateJumpMovement() {
		var jumpMovement:Float = currentJumpPower * currentDeltaTime;

		if (currentJumpPower <= 0 || this.y > JUMP_BORDER) {
			this.y -= jumpMovement;
		}
		realY -= jumpMovement;
		currentJumpPower -= verticalPull;
	}

	function stopJump() {
		isJumping = false;
		realY = this.y = floor - this.height;
	}

	/**
		Activates a super jump, which allows the hero to jump higher than normal.
	**/
	public function activateSuperJump() {
		isSuperJumpPending = true;
		jump();
	}

	/**
		Resets the hero's position to the center of the stage and stops any jumping.
	**/
	public function die() {
		active = false;
		stopJump();
		this.x = stage.stageWidth / 2 - this.width / 2;
	}

	function checkForThePositionChange() {
		if (this.x <= -1 * (this.width)) {
			this.x = stage.stageWidth;
		} else if (this.x >= stage.stageWidth) {
			this.x = -1 * (this.width);
		}
	}
}
